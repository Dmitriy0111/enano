`ifndef APB_RUN_ITEM_TEST__SV
`define APB_RUN_ITEM_TEST__SV

class apb_run_item_test extends apb_base_test;
    `uvm_component_utils(apb_run_item_test)

    typedef apb_rand_seq run_seq;
    run_seq seq0;

    extern function new(string name, uvm_component parent = null);
    extern task main_phase(uvm_phase phase);
    
endclass : apb_run_item_test

function apb_run_item_test::new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction : new

task apb_run_item_test::main_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info ("TB/TRACE/RUN_ITEM","start sequence", UVM_NONE)
    seq0 = run_seq::type_id::create("seq0");
    seq0.start(env.apb.sqr);
    `uvm_info ("TB/TRACE/RUN_ITEM","finish sequence", UVM_NONE)
    #1000;
    phase.drop_objection(this);
endtask : main_phase

`endif // APB_RUN_ITEM_TEST__SV
