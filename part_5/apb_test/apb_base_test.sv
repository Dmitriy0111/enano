`ifndef APB_BASE_TEST__SV
`define APB_BASE_TEST__SV

class apb_base_test extends uvm_test;
    `uvm_component_utils(apb_base_test)

    typedef virtual apb_if apb_vif;

    apb_env     env;
    apb_vif     vif;

    extern function new(string name, uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void start_of_simulation_phase(uvm_phase phase);
    
endclass : apb_base_test

function apb_base_test::new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void apb_base_test::build_phase(uvm_phase phase);
    env = apb_env::type_id::create("env", this);
endfunction : build_phase

function void apb_base_test::start_of_simulation_phase(uvm_phase phase);
    `uvm_info ("BASE_TEST","all test env was built", UVM_LOW)
endfunction : start_of_simulation_phase

`endif // APB_BASE_TEST__SV
