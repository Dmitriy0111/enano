`ifndef RUN_ITEM_TEST__SV
`define RUN_ITEM_TEST__SV

import      uvm_pkg::*;
`include    "uvm_macros.svh"

import task_3_uart_pkg::*;

class run_item_test extends uart_base_test;
    typedef uart_rand_seq RUN_SEQ;

    RUN_SEQ seq0;

    `uvm_component_utils(run_item_test)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info ("TB/TRACE/RUN_ITEM","start sequence", UVM_NONE)
        seq0 = RUN_SEQ::type_id::create("seq0");
        seq0.start(env.uart_agent_.sqr);
        `uvm_info ("TB/TRACE/RUN_ITEM","finish sequence", UVM_NONE)
        #1000;
        phase.drop_objection(this);
    endtask
endclass : run_item_test

`endif // RUN_ITEM_TEST__SV
