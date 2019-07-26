`ifndef APB_ENV__SV
`define APB_ENV__SV

class apb_env extends uvm_env;
    `uvm_component_utils(apb_env)

    typedef virtual apb_if apb_vif;

    apb_agent   apb;
    apb_vif     vif;

    extern function new(string name, uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task pre_reset_phase(uvm_phase phase);
    extern task reset_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);

endclass : apb_env

function apb_env::new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void apb_env::build_phase(uvm_phase phase);
    if ( ! uvm_config_db#(apb_vif)::get(this, "", "apb_vif", vif) )
        `uvm_fatal("TB|ENV|NO_VIF", "No virtual interface specified for environment instance")
    apb = apb_agent#()::type_id::create("apb", this);
    uvm_config_db#(apb_vif)::set(this, "apb", "apb_vif", vif);
endfunction : build_phase

function void apb_env::connect_phase(uvm_phase phase);
endfunction : connect_phase

task apb_env::pre_reset_phase(uvm_phase phase);
    phase.raise_objection(this, "Waiting for reset to be valid");
    wait (vif.presetn !== 1'bx);
    phase.drop_objection(this, "Reset is no longer X");
endtask : pre_reset_phase

task apb_env::reset_phase(uvm_phase phase);
    phase.raise_objection(this, "Asserting reset for 10 clock cycles");
    `uvm_info("TB/TRACE", "Resetting DUT...", UVM_NONE);
    vif.presetn = 1'b1;
    repeat (10) @(posedge vif.pclk);
    vif.presetn = 1'b0;
    phase.drop_objection(this, "HW reset done");
endtask : reset_phase

function void apb_env::report_phase(uvm_phase phase);
    uvm_report_server svr;
    svr = uvm_report_server::get_server();
    if (svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) == 0)
        $write("** UVM TEST PASSED **\n");
    else
        $write("!! UVM TEST FAILED !!\n");
endfunction : report_phase

`endif // APB_ENV__SV
