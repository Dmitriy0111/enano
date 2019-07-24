`ifndef UART_AGENT__SV
`define UART_AGENT__SV

import      uvm_pkg::*;
`include    "uvm_macros.svh"

import task_3_uart_pkg::*;

class uart_agent extends uvm_agent;

    typedef virtual uart_if uart_vif;

    uart_sequencer  sqr;
    uart_driver     drv;
    uart_monitor    mon;
    uart_agent_cfg  cfg;
    uart_vif        uart_if_;

    `uvm_component_utils_begin(uart_agent)
        `uvm_field_object( sqr , UVM_ALL_ON )
        `uvm_field_object( drv , UVM_ALL_ON )
        `uvm_field_object( mon , UVM_ALL_ON )
        `uvm_field_object( cfg , UVM_ALL_ON )
    `uvm_component_utils_end

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(uart_agent_cfg)::get(this,"","uart_cfg", cfg)) 
        begin
            `uvm_info ("UART/AGT/NOCFG","object configuration not set, it will use local configuration",UVM_HIGH)
        end
        if (cfg == null) 
        begin
            cfg = new("cfg");
            cfg.set_default();
        end
        if (cfg.is_active) 
        begin
            if (cfg.master) 
            begin
                sqr = uart_sequencer::type_id::create("sqr", this);
                drv = uart_driver::type_id::create("drv", this);
                uvm_config_db#(uart_agent_cfg)::set(this, "drv", "uart_cfg", cfg);
                uvm_config_db#(uart_agent_cfg)::set(this, "sqr", "uart_cfg", cfg);
            end 
            else 
            begin
                // create slave uart_agent
            end
        end
        mon = uart_monitor::type_id::create("mon", this);
        uvm_config_db#(uart_agent_cfg)::set(this, "mon", "uart_cfg", cfg);
        if (!uvm_config_db#(uart_vif)::get(this, "", "uart_vif", uart_if_)) 
        begin
            `uvm_fatal("APB/AGT/NOVIF", "No virtual interface specified for this agent instance")
        end
        uvm_config_db#(uart_vif)::set(this, "drv", "uart_vif", uart_if_);
        uvm_config_db#(uart_vif)::set(this, "mon", "uart_vif", uart_if_);
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction : connect_phase

endclass : uart_agent

`endif // UART_AGENT__SV
