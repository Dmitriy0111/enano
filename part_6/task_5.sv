import uvm_pkg::*;
`include "uvm_macros.svh"

///////////////////////////////////////////////////////////////////
//  Class: task_5_item
//
class task_5_item extends uvm_sequence_item;

    rand    integer     addr;

    `uvm_object_utils_begin(task_5_item)
        `uvm_field_int( addr , UVM_DEFAULT )
    `uvm_object_utils_end

    extern function new(string name = "task_5_item");
    extern function string convert2string();
    
endclass : task_5_item

function task_5_item::new(string name = "task_5_item");
    super.new(name);
endfunction : new

function string task_5_item::convert2string();
    string s;
    s = super.convert2string();
    $sformat(s, "%sADDR: <0x%h> ", s, addr);
    return s;
endfunction : convert2string
///////////////////////////////////////////////////////////////////
//  Class: task_5_base_seq
//
class task_5_base_seq extends uvm_sequence#(task_5_item);

    task_5_item item;

    `uvm_object_utils_begin(task_5_base_seq)
        `uvm_field_object(item, UVM_ALL_ON | UVM_NOPACK);
    `uvm_object_utils_end

    extern function new(string name="task_5_base_seq");

endclass : task_5_base_seq

function task_5_base_seq::new(string name="task_5_base_seq");
    super.new(name);
endfunction
///////////////////////////////////////////////////////////////////
//  Class: task_5_seq
//
class task_5_seq extends task_5_base_seq;
    `uvm_object_utils(task_5_seq)

    extern function new(string name="task_5_seq");
    extern virtual task body();

endclass : task_5_seq

function task_5_seq::new(string name="task_5_seq");
    super.new(name);
endfunction : new

task task_5_seq::body();
    item = task_5_item::type_id::create("item");
    item.randomize();
    `uvm_info(this.get_name() ,item.convert2string(), UVM_LOW);
endtask : body
///////////////////////////////////////////////////////////////////
//  Class: task_5_sequencer
//
class task_5_sequencer extends uvm_sequencer #(task_5_item);
    `uvm_component_utils(task_5_sequencer)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

endclass : task_5_sequencer
///////////////////////////////////////////////////////////////////
//  Class: task_5_test
//
class task_5_test extends uvm_test;

    task_5_sequencer    seqr_0;
    task_5_seq          seq_0;
    task_5_seq          seq_1;

    `uvm_component_utils(task_5_test)

    extern function new(string name, uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);

endclass : task_5_test

function task_5_test::new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void task_5_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    seqr_0 = task_5_sequencer::type_id::create("seqr_0",this);
    
    seq_0 = task_5_seq::type_id::create("seq_0", this);
    
    seq_1 = task_5_seq::type_id::create("seq_1", this);

endfunction : build_phase

task task_5_test::run_phase(uvm_phase phase);
    super.run_phase(phase);
    repeat(100)
    fork
        seq_0.start( seqr_0 , .this_priority(90) );
        seq_1.start( seqr_0 , .this_priority(10) );
    join
    #200;
endtask : run_phase
///////////////////////////////////////////////////////////////////
//  Module: task_5
//
module task_5;

    initial begin
        run_test("task_5_test");
    end

endmodule : task_5
