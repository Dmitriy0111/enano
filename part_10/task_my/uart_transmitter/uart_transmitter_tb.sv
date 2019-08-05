`timescale 1ns/1ns

module uart_transmitter_tb();

    parameter   T = 10,
                rst_delay = 7,
                repeat_n = 400;

    logic   [0  : 0]    clk;
    logic   [0  : 0]    resetn;
    logic   [15 : 0]    comp;
    logic   [0  : 0]    tr_en;
    logic   [7  : 0]    tx_data;
    logic   [0  : 0]    req;
    logic   [0  : 0]    req_ack;
    logic   [0  : 0]    uart_tx;

    uart_transmitter 
    uart_transmitter_0
    (
        .clk        ( clk       ),
        .resetn     ( resetn    ),
        .comp       ( comp      ),
        .tr_en      ( tr_en     ),
        .tx_data    ( tx_data   ),
        .req        ( req       ),
        .req_ack    ( req_ack   ),
        .uart_tx    ( uart_tx   )
    );

    task write_uart(logic [7 : 0] tx_data_v, logic [15 : 0] comp_v);
        comp = comp_v;
        tx_data = tx_data_v;
        tr_en = '1;
        req = '1;
        @(posedge clk);
        req = '0;
        @(posedge req_ack);
        @(posedge clk);
    endtask : write_uart

    task read_uart();
        reg [7 : 0] rec_data;
        @(negedge uart_tx);
        repeat( comp ) @(posedge clk);
        repeat( 8 )
        begin
            repeat( comp / 2 ) @(posedge clk);
            rec_data = { uart_tx , rec_data[7 : 1] };
            repeat( comp / 2 ) @(posedge clk);
        end
        repeat( comp ) @(posedge clk);
        $display("Received data = 0x%h at time %tns", rec_data, $time());
    endtask : read_uart

    task clean_signals();
        begin
            comp = '0;
            tx_data = '0;
            tr_en = '0;
            req = '0;
        end
    endtask : clean_signals

    initial
    begin
        clk = '0;
        forever
            #(T/2) clk = !clk;
    end
    initial
    begin
        resetn = '0;
        repeat( rst_delay ) @(posedge clk);
        resetn = '1;
    end
    initial
    begin
        logic   [7  : 0]    tx_data_v;
        logic   [15 : 0]    comp_v;
        clean_signals();
        @(posedge resetn);
        repeat( repeat_n )
        begin
            tx_data_v = $urandom_range(0,255);
            $write("Random Tx data = 0x%h ", tx_data_v);
            case($urandom_range(0,4))
                0   : begin comp_v = 50_000_000 / 9600;   $display("random baudrate = 9600");   end
                1   : begin comp_v = 50_000_000 / 19200;  $display("random baudrate = 19200");  end
                2   : begin comp_v = 50_000_000 / 38400;  $display("random baudrate = 38400");  end
                3   : begin comp_v = 50_000_000 / 57600;  $display("random baudrate = 57600");  end
                4   : begin comp_v = 50_000_000 / 115200; $display("random baudrate = 115200"); end
            endcase
            write_uart( tx_data_v , comp_v );
        end
    end
    initial
    begin
        repeat( repeat_n )
            read_uart();
        $stop;
    end
    
endmodule : uart_transmitter_tb
