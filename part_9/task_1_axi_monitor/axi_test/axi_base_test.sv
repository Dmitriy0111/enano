`ifndef AXI_BASE_TEST__SV
`define AXI_BASE_TEST__SV

class axi_base_test extends uvm_test;
    `uvm_component_utils(axi_base_test)

    typedef virtual axi_if axi_vif;

    axi_env     env;
    axi_vif     vif;

    extern function      new(string name, uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void start_of_simulation_phase(uvm_phase phase);
    
endclass : axi_base_test

function axi_base_test::new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void axi_base_test::build_phase(uvm_phase phase);
    env = axi_env::type_id::create("env", this);
    if( !uvm_config_db#(axi_vif)::get(this, "", "axi_vif", vif) )
        `uvm_fatal("AXI|ENV|NO_VIF", "No virtual interface specified")
endfunction : build_phase

function void axi_base_test::start_of_simulation_phase(uvm_phase phase);
    `uvm_info ("BASE_TEST","all test env was built", UVM_LOW)
endfunction : start_of_simulation_phase

`endif // AXI_BASE_TEST__SV
