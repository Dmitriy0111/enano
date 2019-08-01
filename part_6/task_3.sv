import uvm_pkg::*;
`include "uvm_macros.svh"

///////////////////////////////////////////////////////////////////
//  Class: task_3_item
//
class task_3_item extends uvm_sequence_item;

    rand    integer     addr;

    `uvm_object_utils_begin(task_3_item)
        `uvm_field_int( addr , UVM_DEFAULT )
    `uvm_object_utils_end

    extern function new(string name = "task_3_item");
    extern function string convert2string();
    
endclass : task_3_item

function task_3_item::new(string name = "task_3_item");
    super.new(name);
endfunction : new

function string task_3_item::convert2string();
    string s;
    s = super.convert2string();
    $sformat(s, "%sADDR: <0x%h> ", s, addr);
    return s;
endfunction : convert2string
///////////////////////////////////////////////////////////////////
//  Class: task_3_base_seq
//
class task_3_base_seq extends uvm_sequence#(task_3_item);

    task_3_item item;

    `uvm_object_utils_begin(task_3_base_seq)
        `uvm_field_object(item, UVM_ALL_ON | UVM_NOPACK);
    `uvm_object_utils_end

    extern function new(string name="task_3_base_seq");

endclass : task_3_base_seq

function task_3_base_seq::new(string name="task_3_base_seq");
    super.new(name);
endfunction
///////////////////////////////////////////////////////////////////
//  Class: task_3_seq
//
class task_3_seq extends task_3_base_seq;
    `uvm_object_utils(task_3_seq)

    integer     addr_i;

    integer     addr_0 = 0;
    integer     addr_1 = 255;
    integer     step = 3;

    extern function new(string name="task_3_seq");
    extern virtual task edit_addr();
    extern virtual task body();

endclass : task_3_seq

function task_3_seq::new(string name="task_3_seq");
    super.new(name);
endfunction : new

task task_3_seq::edit_addr();
    for( addr_i = addr_0 ; addr_i <= addr_1 ; addr_i += step ) 
    begin
        item = task_3_item::type_id::create("item");
        item.randomize() with { addr == addr_i; };
        // start_item(item);
        // finish_item(item);
        item.print();
    end
endtask : edit_addr

task task_3_seq::body();
    edit_addr();
endtask : body
///////////////////////////////////////////////////////////////////
//  Class: task_3_sequencer
//
class task_3_sequencer extends uvm_sequencer #(task_3_item);
    `uvm_component_utils(task_3_sequencer)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

endclass : task_3_sequencer
///////////////////////////////////////////////////////////////////
//  Class: task_3_test
//
class task_3_test extends uvm_test;

    task_3_sequencer seqr;
    task_3_seq task_3_seq_;

    `uvm_component_utils(task_3_test)

    extern function new(string name, uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);

endclass : task_3_test

function task_3_test::new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void task_3_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    seqr = task_3_sequencer::type_id::create("seqr",this);
    task_3_seq_ = task_3_seq::type_id::create("task_3_seq_", this);
endfunction : build_phase

task task_3_test::run_phase(uvm_phase phase);
    super.run_phase(phase);
    task_3_seq_.start(seqr);
    #200;
endtask : run_phase
///////////////////////////////////////////////////////////////////
//  Module: task_3
//
module task_3;

    initial begin
        run_test("task_3_test");
    end

endmodule : task_3
