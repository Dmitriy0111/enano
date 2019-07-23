`ifndef UART_DRIVER__SV
`define UART_DRIVER__SV

import      uvm_pkg::*;
`include    "uvm_macros.svh"

import task_3_uart_pkg::*;

class uart_driver extends uvm_driver #(uart_item);
    `uvm_object_utils(uart_driver)

    virtual uart_if uart_if_;

    uart_agent_cfg  cfg;


    function new(string name = "uart_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        if( ! uvm_config_db#(virtual uart_if)::get(this,"","uart_if", uart_if_) )
        begin
            `uvm_fatal("UART/DRV/NOVIF", "No virtual interface specified for this driver instance")
        end
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        @(posedge uart_if_.resetn);
        forever 
        begin
            uart_item uart_item_;
            seq_item_port.get_next_item(uart_item_);
            @(posedge uart_if_.clk);
            uart_if_.tx_data   = uart_item_.tx_data;
            uart_if_.stop      = uart_item_.stop;
            uart_if_.parity_en = uart_item_.parity_en;
            uart_if_.baudrate  = 50_000_000 / uart_item_.baudrate;
            uart_if_.req = '1;
            @(posedge uart_if_.req_ack);
            uart_if_.req = '0;
        end
    endtask : run_phase

endclass : uart_driver

`endif // UART_DRIVER__SV
