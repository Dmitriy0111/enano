`ifndef APB_AGENT__SV
`define APB_AGENT__SV

//  Class: apb_agent
//
class apb_agent#(type apb_vif = virtual apb_if) extends uvm_agent;

    uvm_analysis_port   #( apb_item )   apb_agt_ap;

    apb_driver      apb_drv;
    apb_monitor     apb_mon;
    apb_agent_cfg   apb_agt_cfg;
    apb_sequencer   apb_sqr;
    apb_vif         vif;

    `uvm_component_utils_begin( apb_agent#(apb_vif) )
        `uvm_field_object( apb_drv     , UVM_DEFAULT )
        `uvm_field_object( apb_mon     , UVM_DEFAULT )
        `uvm_field_object( apb_agt_cfg , UVM_DEFAULT )
        `uvm_field_object( apb_sqr     , UVM_DEFAULT )
    `uvm_component_utils_end

    extern function new(string name = "apb_agent", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    
endclass : apb_agent

function apb_agent::new(string name = "apb_agent", uvm_component parent = null);
    super.new(name, parent);
    apb_agt_ap = new("apb_agt_ap", this);
endfunction : new

function void apb_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    $display(this.get_name());
    if( !uvm_config_db#(apb_agent_cfg)::get(this, "", this.get_name(), apb_agt_cfg) )
        `uvm_info("APB|AGT|NO_CFG", "No agent configuration detected.", UVM_LOW)
    if( apb_agt_cfg == null )
    begin
        apb_agt_cfg = new("apb_agt_cfg");
        apb_agt_cfg.set_default();
    end
    if( apb_agt_cfg.is_active )
    begin
        if( apb_agt_cfg.is_master )
        begin
            apb_sqr = apb_sequencer::type_id::create("apb_sqr", this);
            apb_drv = apb_driver#()::type_id::create("apb_drv", this);
            uvm_config_db#(apb_agent_cfg)::set(this, "apb_drv", "apb_cfg", apb_agt_cfg);
            uvm_config_db#(apb_agent_cfg)::set(this, "apb_sqr", "apb_cfg", apb_agt_cfg);
        end
        else
        begin
            apb_drv = apb_driver#()::type_id::create("apb_drv", this);
            uvm_config_db#(apb_agent_cfg)::set(this, "apb_drv", "apb_cfg", apb_agt_cfg);
        end
    end
    apb_mon = apb_monitor#()::type_id::create("apb_mon",this);
    uvm_config_db#(apb_agent_cfg)::set(this, "apb_mon", "apb_cfg", apb_agt_cfg);
    
    if( !uvm_config_db#(apb_vif)::get(this, "", "apb_vif", vif) )
        `uvm_fatal("APB|AGT|NO_VIF", "No virtual interface specified")
    uvm_config_db#(apb_vif)::set(this, "apb_mon", "apb_vif", vif);
    uvm_config_db#(apb_vif)::set(this, "apb_drv", "apb_vif", vif);
endfunction : build_phase

function void apb_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (apb_agt_cfg.is_active) 
    begin
        if (apb_agt_cfg.is_master) 
        begin
            apb_drv.seq_item_port.connect(apb_sqr.seq_item_export);
        end
    end
    apb_mon.apb_mon_ap.connect(apb_agt_ap);
endfunction : connect_phase

`endif // APB_AGENT__SV
