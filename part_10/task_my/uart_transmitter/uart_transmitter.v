module uart_transmitter
(
    input   wire    [0  : 0]    clk,
    input   wire    [0  : 0]    resetn,
    input   wire    [15 : 0]    comp,
    input   wire    [0  : 0]    tr_en,
    input   wire    [7  : 0]    tx_data,
    input   wire    [0  : 0]    req,
    output  reg     [0  : 0]    req_ack,
    output  reg     [0  : 0]    uart_tx
);

    localparam          IDLE_s     = 3'b000,
                        START_s    = 3'b001,
                        TRANSMIT_s = 3'b010,
                        STOP_s     = 3'b011,
                        WAIT_s     = 3'b100;

    wire    [0  : 0]    idle2start;
    wire    [0  : 0]    start2transmit;
    wire    [0  : 0]    transmit2stop;
    wire    [0  : 0]    stop2wait;
    wire    [0  : 0]    wait2idle;
                        
    reg     [15 : 0]    comp_int;
    reg     [7  : 0]    tx_data_int;
    reg     [2  : 0]    state;
    reg     [2  : 0]    next_state;
    reg     [15 : 0]    count;
    reg     [2  : 0]    bit_c;

    assign idle2start       = ( req     == 1'b1 );
    assign start2transmit   = ( count >= comp_int );
    assign transmit2stop    = ( ( count >= comp_int ) && ( bit_c == 3'b111 ) );
    assign stop2wait        = ( count >= comp_int );
    assign wait2idle        = ( req_ack == 1'b1 );

    always @(posedge clk, negedge resetn)
        if( !resetn )
            state <= IDLE_s;
        else
            state <= tr_en ? next_state : IDLE_s;

    always @(*)
    begin
        next_state = state;
        case( state )
            IDLE_s      : next_state = ( idle2start     == 1'b1 ) ? START_s    : state;
            START_s     : next_state = ( start2transmit == 1'b1 ) ? TRANSMIT_s : state;
            TRANSMIT_s  : next_state = ( transmit2stop  == 1'b1 ) ? STOP_s     : state;
            STOP_s      : next_state = ( stop2wait      == 1'b1 ) ? WAIT_s     : state;
            WAIT_s      : next_state = ( wait2idle      == 1'b1 ) ? IDLE_s     : state;
            default     : next_state = IDLE_s;
        endcase
    end

    always @(posedge clk, negedge resetn)
        if( !resetn )
        begin
            comp_int <= 16'h00;
            tx_data_int <= 8'h0;
            count <= 16'h00;
            bit_c <= 3'b000;
            uart_tx <= 1'b1;
            req_ack <= 1'b0;
        end
        else
        begin
            if( tr_en == 1'b1 )
                case( state )
                    IDLE_s      : 
                        begin
                            req_ack <= 1'b0;
                            if( idle2start )
                            begin
                                comp_int <= comp;
                                tx_data_int <= tx_data;
                            end
                        end
                    START_s     : 
                        begin
                            uart_tx <= 1'b0;
                            count <= count + 16'h01;
                            if( start2transmit )
                                count <= 16'h00;
                        end
                    TRANSMIT_s  : 
                        begin
                            uart_tx <= tx_data_int[bit_c];
                            count <= count + 16'h01;
                            if( count >= comp_int )
                            begin
                                count <= 16'h00;
                                bit_c <= bit_c + 3'b001;
                            end
                            if( transmit2stop == 1'b1)
                            begin
                                count <= 16'h00;
                                bit_c <= 3'b000;
                            end
                        end
                    STOP_s      : 
                        begin
                            uart_tx <= 1'b1;
                            count <= count + 16'h01;
                            if( stop2wait )
                                count <= 16'h00;
                        end
                    WAIT_s      : 
                        req_ack <= 1'b1;
                    default     : ;
                endcase
            else
            begin
                comp_int <= 16'h00;
                tx_data_int <= 8'h0;
                count <= 16'h00;
                bit_c <= 3'b000;
                uart_tx <= 1'b1;
                req_ack <= 1'b0;
            end
        end

endmodule // uart_tx
