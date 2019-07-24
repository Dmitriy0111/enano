
module top();

    import      uvm_pkg::*;
    `include    "uvm_macros.svh"

    import      task_3_uart_pkg::*;

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
        run_test("run_item_test");
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
            repeat(baudrate) @(posedge uart_if_.clk);
            uart_if_.req_ack = '1;
            @(posedge uart_if_.clk);
            uart_if_.req_ack = '0;
        end
    end

endmodule
