`ifndef APB_BASE_TEST__SV
`define APB_BASE_TEST__SV

import      uvm_pkg::*;
`include    "uvm_macros.svh"

import task_3_apb_pkg_ex::*;

class apb_base_test extends uvm_test;

    typedef virtual apb_if apb_vif; 

    tb_env env;
    apb_vif vif;

    `uvm_component_utils(apb_base_test)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        env = tb_env::type_id::create("env", this);
    endfunction : build_phase

    function void start_of_simulation_phase(uvm_phase phase);
        // uvm_coreservice_t cs_ = uvm_coreservice_t::get();
        // uvm_root top = cs_.get_root();
        // $cast(env, top.find("env"));
        `uvm_info ("BASE_TEST","all test env was built", UVM_LOW)
    endfunction : start_of_simulation_phase

endclass : apb_base_test

`endif // APB_BASE_TEST__SV