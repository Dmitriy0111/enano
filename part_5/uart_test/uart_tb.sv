module uart_tb();

    import      uvm_pkg::*;
    `include    "uvm_macros.svh"

    import uart_run_item_test_pkg::*;

    typedef virtual uart_if uart_vif;

    logic   [0 : 0]     clk;
    logic   [0 : 0]     resetn;

    uart_if     uart_if_( clk , resetn );

    initial begin
        clk = 0;
        forever
            #(10) clk = !clk;
    end

    initial begin
        run_test(  );
    end
    initial begin
        uvm_config_db#(uart_vif)::set(uvm_root::get(), "", "uart_vif", uart_if_);
    end
    initial 
    begin
        $dumpfile ("dump.vcd");
    end
    initial
    begin
        logic   [7  : 0]    tx_data;
        logic   [15 : 0]    baudrate;
        uart_if_.uart_tx = '1;
        uart_if_.req_ack = '0;
        @(posedge uart_if_.resetn);
        forever
        begin
            @(posedge uart_if_.req);
            tx_data = uart_if_.tx_data;
            baudrate = uart_if_.baudrate;
            uart_if_.uart_tx = '0;
            repeat(baudrate) @(posedge uart_if_.clk);
            repeat( 8 )
            begin
                uart_if_.uart_tx = tx_data[0];
                tx_data = tx_data >> 1;
                repeat(baudrate) @(posedge uart_if_.clk);
            end
            uart_if_.uart_tx = '1;
            repeat(uart_if_.stop) repeat(baudrate/2) @(posedge uart_if_.clk);
            uart_if_.req_ack = '1;
            @(posedge uart_if_.clk);
            uart_if_.req_ack = '0;
        end
    end

    /* initial
    begin
        logic   [7  : 0]    tx_data;
        integer             baudrate;
        integer             delay;
        logic   [1  : 0]    stop;
        uart_if_.uart_tx = '1;
        uart_if_.req = '0;
        uart_if_.req_ack = '0;
        uart_if_.parity_en = '0;
        @(posedge uart_if_.resetn);
        forever
        begin
            tx_data = $urandom_range(0,255);
            $display("Tx data = 0x%h", tx_data);
            case( $urandom_range(0,4) )
                0       : begin baudrate = 9600;   $display("Baudrate = 0x%d", baudrate); end
                1       : begin baudrate = 19200;  $display("Baudrate = 0x%d", baudrate); end
                2       : begin baudrate = 38400;  $display("Baudrate = 0x%d", baudrate); end
                3       : begin baudrate = 57600;  $display("Baudrate = 0x%d", baudrate); end
                4       : begin baudrate = 115200; $display("Baudrate = 0x%d", baudrate); end
                default : begin baudrate = 9600;   $display("Baudrate = 0x%d", baudrate); end
            endcase
            baudrate = 50_000_000 / baudrate;
            uart_if_.baudrate = baudrate;
            delay = $urandom_range(100,1000);
            stop = $urandom_range(0,3);
            uart_if_.uart_tx = '0;
            uart_if_.stop = stop;
            repeat(baudrate) @(posedge uart_if_.clk);
            repeat( 8 )
            begin
                uart_if_.uart_tx = tx_data[0];
                tx_data = tx_data >> 1;
                repeat(baudrate) @(posedge uart_if_.clk);
            end
            uart_if_.uart_tx = '1;
            repeat(stop) repeat(baudrate/2) @(posedge uart_if_.clk);
            repeat(delay) @(posedge uart_if_.clk);
        end
    end */

endmodule : uart_tb
