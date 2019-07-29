`ifndef AXI_RUN_TEST__SV
`define AXI_RUN_TEST__SV

class axi_run_test extends axi_base_test;
    `uvm_component_utils(axi_run_test)

    axi_rand_seq    seq0;

    extern function new(string name, uvm_component parent = null);
    extern task main_phase(uvm_phase phase);
    
endclass : axi_run_test

function axi_run_test::new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction : new

task axi_run_test::main_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info ("TB/TRACE/RUN_ITEM","start sequence", UVM_NONE)
    seq0 = axi_rand_seq::type_id::create("seq0");
    seq0.start(env.axi_agt.axi_sqr);
    repeat(200) @(posedge vif.ACLK);
    `uvm_info ("TB/TRACE/RUN_ITEM","finish sequence", UVM_NONE)
    #1000;
    phase.drop_objection(this);
endtask : main_phase

`endif // AXI_RUN_TEST__SV
