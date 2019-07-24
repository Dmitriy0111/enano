`ifndef APB_AGENT__SV
`define APB_AGENT__SV

import      uvm_pkg::*;
`include    "uvm_macros.svh"

import task_3_apb_pkg_ex::*;

class apb_agent extends uvm_agent;

    typedef virtual apb_if apb_vif; 

    apb_sequencer   sqr;
    apb_master      drv;
    apb_monitor     mon;
    apb_vif         vif;
    apb_agent_cfg   cfg;

    `uvm_component_utils_begin(apb_agent)
        `uvm_field_object(sqr, UVM_ALL_ON)
        `uvm_field_object(drv, UVM_ALL_ON)
        `uvm_field_object(mon, UVM_ALL_ON)
        `uvm_field_object(cfg, UVM_ALL_ON)
    `uvm_component_utils_end

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(apb_agent_cfg)::get(this,"","apb_cfg", cfg)) 
        begin
            `uvm_info ("APB/AGT/NOCFG","object configuration not set, it will use local configuration",UVM_HIGH)
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
                sqr = apb_sequencer::type_id::create("sqr", this);
                drv = apb_master::type_id::create("drv", this);
                uvm_config_db#(apb_agent_cfg)::set(this, "drv", "apb_cfg", cfg);
                uvm_config_db#(apb_agent_cfg)::set(this, "sqr", "apb_cfg", cfg);
            end 
            else 
            begin
                // create slave apb_agent
            end
        end
        mon = apb_monitor::type_id::create("mon", this);
        uvm_config_db#(apb_agent_cfg)::set(this, "mon", "apb_cfg", cfg);
        if (!uvm_config_db#(apb_vif)::get(this, "", "apb_vif", vif)) 
        begin
            `uvm_fatal("APB/AGT/NOVIF", "No virtual interface specified for this agent instance")
        end
        uvm_config_db#(apb_vif)::set(this, "drv", "apb_vif", vif);
        uvm_config_db#(apb_vif)::set(this, "mon", "apb_vif", vif);
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction : connect_phase

endclass: apb_agent

`endif // APB_AGENT__SV
