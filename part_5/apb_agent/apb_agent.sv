`ifndef APB_AGENT__SV
`define APB_AGENT__SV

class apb_agent#(type apb_vif = virtual apb_if) extends uvm_agent;

    apb_sequencer                       sqr;
    apb_driver                          drv;
    apb_monitor                         mon;
    apb_vif                             vif;
    apb_agent_cfg                       cfg;

    uvm_analysis_port   #(apb_item)     agt_ap;

    `uvm_component_utils_begin( apb_agent#(apb_vif) )
        `uvm_field_object( sqr , UVM_ALL_ON )
        `uvm_field_object( drv , UVM_ALL_ON )
        `uvm_field_object( mon , UVM_ALL_ON )
        `uvm_field_object( cfg , UVM_ALL_ON )
    `uvm_component_utils_end

    extern function new(string name, uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

endclass : apb_agent

function apb_agent::new(string name, uvm_component parent = null);
    super.new(name, parent);
    agt_ap = new( "agt_ap" , this );
endfunction : new

function void apb_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if ( ! uvm_config_db#(apb_agent_cfg)::get(this,"","apb_cfg", cfg) )
        `uvm_info ("APB|AGT|NO_CFG","object configuration not set, it will use local configuration",UVM_LOW)
    if (cfg == null) 
    begin
        cfg = new("cfg");
        cfg.set_default();
    end
    if (cfg.is_active) 
    begin
        if (cfg.is_master) 
        begin
            sqr = apb_sequencer::type_id::create("sqr", this);
            drv = apb_driver#()::type_id::create("drv", this);
            uvm_config_db#(apb_agent_cfg)::set(this, "drv", "apb_cfg", cfg);
            uvm_config_db#(apb_agent_cfg)::set(this, "sqr", "apb_cfg", cfg);
        end 
        else 
        begin
            // create slave apb_agent
        end
    end
    mon = apb_monitor#()::type_id::create("mon", this);
    uvm_config_db#(apb_agent_cfg)::set(this, "mon", "apb_cfg", cfg);
    if( ! uvm_config_db#(apb_vif)::get(this, "", "apb_vif", vif) )
        `uvm_fatal("APB|AGT|NO_VIF", "No virtual interface specified for this agent instance")
    uvm_config_db#(apb_vif)::set(this, "drv", "apb_vif", vif);
    uvm_config_db#(apb_vif)::set(this, "mon", "apb_vif", vif);
endfunction : build_phase

function void apb_agent::connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
    mon.mon_ap.connect(agt_ap);
endfunction : connect_phase

`endif // APB_AGENT__SV
