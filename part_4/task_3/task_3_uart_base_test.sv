`ifndef UART_BASE_TEST__SV
`define UART_BASE_TEST__SV

import      uvm_pkg::*;
`include    "uvm_macros.svh"

import task_3_uart_pkg::*;

class uart_base_test extends uvm_test;

    typedef virtual uart_if uart_vif;

    uart_env env;
    uart_vif uart_if_;

    `uvm_component_utils(uart_base_test)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        env = uart_env::type_id::create("env", this);
    endfunction : build_phase

    function void start_of_simulation_phase(uvm_phase phase);
        // uvm_coreservice_t cs_ = uvm_coreservice_t::get();
        // uvm_root top = cs_.get_root();
        // $cast(env, top.find("env"));
        `uvm_info ("BASE_TEST","all test env was built", UVM_LOW)
    endfunction : start_of_simulation_phase

endclass : uart_base_test

`endif // UART_BASE_TEST__SV
