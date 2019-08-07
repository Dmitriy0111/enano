`ifndef AXI_ENV__SV
`define AXI_ENV__SV

class axi_env extends uvm_env;
    `uvm_component_utils(axi_env)

    typedef virtual axi_if axi_vif;

    axi_agent       axi_agt_0;
    axi_agent       axi_agt_1;
    axi_agent_cfg   axi_agt_cfg_0;
    axi_agent_cfg   axi_agt_cfg_1;
    axi_vif         vif;

    extern function      new(string name, uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task          pre_reset_phase(uvm_phase phase);
    extern task          reset_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);

endclass : axi_env

function axi_env::new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void axi_env::build_phase(uvm_phase phase);
    if ( !uvm_config_db#(axi_vif)::get(this, "", "axi_vif", vif) )
        `uvm_fatal("TB|ENV|NO_VIF", "No virtual interface specified")

    axi_agt_0 = axi_agent#()::type_id::create("axi_agt_0", this);
    axi_agt_1 = axi_agent#()::type_id::create("axi_agt_1", this);

    axi_agt_cfg_0 = axi_agent_cfg::type_id::create("axi_agt_0", this);
    axi_agt_cfg_0.set_master();
    axi_agt_cfg_1 = axi_agent_cfg::type_id::create("axi_agt_1", this);
    axi_agt_cfg_1.set_slave();

    uvm_config_db#(axi_agent_cfg)::set(this, "axi_agt_0", "axi_agt_0", axi_agt_cfg_0);
    uvm_config_db#(axi_agent_cfg)::set(this, "axi_agt_1", "axi_agt_1", axi_agt_cfg_1);
    
    uvm_config_db#(axi_vif)::set(this, "axi_agt_0", "axi_vif", vif);
    uvm_config_db#(axi_vif)::set(this, "axi_agt_1", "axi_vif", vif);
endfunction : build_phase

function void axi_env::connect_phase(uvm_phase phase);
endfunction : connect_phase

task axi_env::pre_reset_phase(uvm_phase phase);
    phase.raise_objection(this, "Waiting for reset to be valid");
    wait (vif.ARESETN !== 1'bx);
    phase.drop_objection(this, "Reset is no longer X");
endtask : pre_reset_phase

task axi_env::reset_phase(uvm_phase phase);
    phase.raise_objection(this, "Asserting reset for 10 clock cycles");
    `uvm_info("TB/TRACE", "Resetting DUT...", UVM_NONE);
    vif.ARESETN = 1'b1;
    repeat (10) @(posedge vif.ACLK);
    vif.ARESETN = 1'b0;
    phase.drop_objection(this, "HW reset done");
endtask : reset_phase

function void axi_env::report_phase(uvm_phase phase);
    uvm_report_server svr;
    svr = uvm_report_server::get_server();
    if (svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) == 0)
        $write("** UVM TEST PASSED **\n");
    else
        $write("!! UVM TEST FAILED !!\n");
endfunction : report_phase

`endif // AXI_ENV__SV
