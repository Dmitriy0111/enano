`ifndef UART_DRIVER__SV
`define UART_DRIVER__SV

import      uvm_pkg::*;
`include    "uvm_macros.svh"

import task_3_uart_pkg::*;

class uart_driver extends uvm_driver #(uart_item);

    typedef virtual uart_if uart_vif;
    
    `uvm_component_utils(uart_driver)
    
    uart_vif uart_if_;

    uart_agent_cfg  cfg;

    function new(string name = "drv", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        if( ! uvm_config_db#(uart_vif)::get(this,"","uart_vif", uart_if_) )
        begin
            `uvm_fatal("UART/DRV/NOVIF", "No virtual interface specified for this driver instance")
        end
    endfunction : build_phase

    task pre_reset_phase(uvm_phase phase);
        wait (uart_if_.resetn !== 1'bx);
        `uvm_info("UART/DRV/TRACE", "Reset is valid", UVM_NONE);
    endtask : pre_reset_phase

    task reset_phase(uvm_phase phase);
        super.reset_phase(phase);
        `uvm_info("UART/DRV/TRACE", "Waiting while DUT in reset", UVM_NONE);
        @(posedge uart_if_.resetn);
        `uvm_info("UART/DRV/TRACE", "Go to run phase", UVM_NONE);
    endtask : reset_phase

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever 
        begin
            uart_item uart_item_;
            seq_item_port.get_next_item(uart_item_);
            @(posedge uart_if_.clk);
            $display(uart_item_.convert2string());
            uart_if_.tx_data   = uart_item_.tx_data;
            uart_if_.stop      = uart_item_.stop;
            uart_if_.parity_en = uart_item_.parity_en;
            uart_if_.baudrate  = 50_000_000 / uart_item_.baudrate;
            uart_if_.req = '1;
            @(posedge uart_if_.req_ack);
            uart_if_.req = '0;
            repeat(uart_item_.delay) @(posedge uart_if_.clk);
            seq_item_port.item_done();
        end
    endtask : run_phase

endclass : uart_driver

`endif // UART_DRIVER__SV
