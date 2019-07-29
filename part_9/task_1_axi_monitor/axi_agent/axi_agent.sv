`ifndef AXI_AGENT__SV
`define AXI_AGENT__SV

//  Class: axi_agent
//
class axi_agent#(type axi_vif = virtual axi_if) extends uvm_agent;

    uvm_analysis_port   #( axi_item )   axi_agt_ap;

    axi_driver      axi_drv;
    axi_monitor     axi_mon;
    axi_agent_cfg   axi_agt_cfg;
    axi_sequencer   axi_sqr;
    axi_vif         vif;

    `uvm_component_utils_begin( axi_agent#(axi_vif) )
        `uvm_field_object( axi_drv     , UVM_DEFAULT )
        `uvm_field_object( axi_mon     , UVM_DEFAULT )
        `uvm_field_object( axi_agt_cfg , UVM_DEFAULT )
        `uvm_field_object( axi_sqr     , UVM_DEFAULT )
    `uvm_component_utils_end

    extern function new(string name = "axi_agent", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    
endclass : axi_agent

function axi_agent::new(string name = "axi_agent", uvm_component parent = null);
    super.new(name, parent);
    axi_agt_ap = new("axi_agt_ap", this);
endfunction : new

function void axi_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if( !uvm_config_db#(axi_agent_cfg)::get(this, "", "axi_cfg", axi_agt_cfg) )
        `uvm_info("AXI|AGT|NO_CFG", "No agent configuration detected.", UVM_LOW)
    if( axi_agt_cfg == null )
    begin
        axi_agt_cfg = new("axi_agt_cfg");
        axi_agt_cfg.set_default();
    end
    if( axi_agt_cfg.is_active )
    begin
        if( axi_agt_cfg.is_master )
        begin
            axi_sqr = axi_sequencer::type_id::create("axi_sqr", this);
            axi_drv = axi_driver#()::type_id::create("axi_drv", this);
            uvm_config_db#(axi_agent_cfg)::set(this, "axi_drv", "axi_cfg", axi_agt_cfg);
            uvm_config_db#(axi_agent_cfg)::set(this, "axi_sqr", "axi_cfg", axi_agt_cfg);
        end
        else
        begin
            `uvm_fatal("AXI|AGT|BAD_CFG", "No configuration for AXI slave")
        end
    end
    axi_mon = axi_monitor#()::type_id::create("axi_mon",this);
    uvm_config_db#(axi_agent_cfg)::set(this, "axi_mon", "axi_cfg", axi_agt_cfg);
    
    if( !uvm_config_db#(axi_vif)::get(this, "", "axi_vif", vif) )
        `uvm_fatal("AXI|AGT|NO_VIF", "No virtual interface specified")
    uvm_config_db#(axi_vif)::set(this, "axi_mon", "axi_vif", vif);
    uvm_config_db#(axi_vif)::set(this, "axi_drv", "axi_vif", vif);
endfunction : build_phase

function void axi_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (axi_agt_cfg.is_active) 
    begin
        if (axi_agt_cfg.is_master) 
        begin
            axi_drv.seq_item_port.connect(axi_sqr.seq_item_export);
        end
    end
    axi_mon.axi_mon_ap.connect(axi_agt_ap);
endfunction : connect_phase

`endif // AXI_AGENT__SV
