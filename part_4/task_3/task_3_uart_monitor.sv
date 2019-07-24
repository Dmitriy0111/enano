`ifndef UART_MONITOR__SV
`define UART_MONITOR__SV

import      uvm_pkg::*;
`include    "uvm_macros.svh"

import task_3_uart_pkg::*;

class uart_monitor extends uvm_monitor;

    typedef virtual uart_if uart_vif;
    
    uart_vif uart_if_;
    uvm_analysis_port   #(uart_item)    ap;
    uart_agent_cfg                      cfg;
    
    `uvm_component_utils(uart_monitor)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        ap = new("ap",this);
        if( ! uvm_config_db#(uart_vif)::get(this,"*","uart_vif", uart_if_) )
        begin
            `uvm_fatal("UART/MON/NOVIF", "No virtual interface specified for this monitor instance")
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        @(posedge uart_if_.resetn);
        forever 
        begin
            uart_item uart_item_;
            @(negedge uart_if_.uart_tx);
            uart_item_ = uart_item::type_id::create("uart_item_", this);
            repeat(50_000_000/115200) @( posedge uart_if_.clk );
            repeat(8)
            begin
                repeat(50_000_000/115200/2) @( posedge uart_if_.clk );
                uart_item_.tx_data = { uart_if_.uart_tx , uart_item_.tx_data[7 : 1] };
                repeat(50_000_000/115200/2) @( posedge uart_if_.clk );
            end
            repeat(50_000_000/115200) @( posedge uart_if_.clk );
            ap.write(uart_item_);
            `uvm_info ("UART/MONITOR",$sformatf("Collect item: \n%s",uart_item_.convert2string()),UVM_LOW)
        end
    endtask : run_phase

endclass : uart_monitor

`endif // UART_MONITOR__SV
