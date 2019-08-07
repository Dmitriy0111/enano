`ifndef AHB_AGENT__SV
`define AHB_AGENT__SV

//  Class: ahb_agent
//
class ahb_agent#(type ahb_vif = virtual ahb_if) extends uvm_agent;

    uvm_analysis_port   #( ahb_item )   ahb_agt_ap;

    ahb_driver      ahb_drv;
    ahb_monitor     ahb_mon;
    ahb_agent_cfg   ahb_agt_cfg;
    ahb_sequencer   ahb_sqr;
    ahb_vif         vif;

    `uvm_component_utils_begin( ahb_agent#(ahb_vif) )
        `uvm_field_object( ahb_drv     , UVM_DEFAULT )
        `uvm_field_object( ahb_mon     , UVM_DEFAULT )
        `uvm_field_object( ahb_agt_cfg , UVM_DEFAULT )
        `uvm_field_object( ahb_sqr     , UVM_DEFAULT )
    `uvm_component_utils_end

    extern function      new(string name = "ahb_agent", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    
endclass : ahb_agent

function ahb_agent::new(string name = "ahb_agent", uvm_component parent = null);
    super.new(name, parent);
    ahb_agt_ap = new("ahb_agt_ap", this);
endfunction : new

function void ahb_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    $display(this.get_name());
    if( !uvm_config_db#(ahb_agent_cfg)::get(this, "", this.get_name(), ahb_agt_cfg) )
        `uvm_info("AHB|AGT|NO_CFG", "No agent configuration detected.", UVM_LOW)
    if( ahb_agt_cfg == null )
    begin
        ahb_agt_cfg = new("ahb_agt_cfg");
        ahb_agt_cfg.set_default();
    end
    if( ahb_agt_cfg.is_active )
    begin
        if( ahb_agt_cfg.is_master )
        begin
            ahb_sqr = ahb_sequencer::type_id::create("ahb_sqr", this);
            ahb_drv = ahb_driver#()::type_id::create("ahb_drv", this);
            uvm_config_db#(ahb_agent_cfg)::set(this, "ahb_drv", "ahb_cfg", ahb_agt_cfg);
            uvm_config_db#(ahb_agent_cfg)::set(this, "ahb_sqr", "ahb_cfg", ahb_agt_cfg);
        end
        else
        begin
            ahb_drv = ahb_driver#()::type_id::create("ahb_drv", this);
            uvm_config_db#(ahb_agent_cfg)::set(this, "ahb_drv", "ahb_cfg", ahb_agt_cfg);
        end
    end
    ahb_mon = ahb_monitor#()::type_id::create("ahb_mon",this);
    uvm_config_db#(ahb_agent_cfg)::set(this, "ahb_mon", "ahb_cfg", ahb_agt_cfg);
    
    if( !uvm_config_db#(ahb_vif)::get(this, "", "ahb_vif", vif) )
        `uvm_fatal("AHB|AGT|NO_VIF", "No virtual interface specified")
    uvm_config_db#(ahb_vif)::set(this, "ahb_mon", "ahb_vif", vif);
    uvm_config_db#(ahb_vif)::set(this, "ahb_drv", "ahb_vif", vif);
endfunction : build_phase

function void ahb_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (ahb_agt_cfg.is_active) 
    begin
        if (ahb_agt_cfg.is_master) 
        begin
            ahb_drv.seq_item_port.connect(ahb_sqr.seq_item_export);
        end
    end
    ahb_mon.ahb_mon_ap.connect(ahb_agt_ap);
endfunction : connect_phase

`endif // AHB_AGENT__SV
