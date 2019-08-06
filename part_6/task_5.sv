import uvm_pkg::*;
`include "uvm_macros.svh"

////////////////////////////////////////////////////////////////////
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
////////////////////////////////////////////////////////////////////
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
////////////////////////////////////////////////////////////////////
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
////////////////////////////////////////////////////////////////////
//  Class: task_5_sequencer
//
class task_5_sequencer extends uvm_sequencer #(task_5_item);
    `uvm_component_utils(task_5_sequencer)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

endclass : task_5_sequencer

////////////////////////////////////////////////////////////////////
//  Class: task_5_vsequence
//
class task_5_vsequence extends uvm_sequence;
    `uvm_object_utils(task_5_vsequence);

    task_5_sequencer    seqr_0;

    task_5_seq          seq_0;
    task_5_seq          seq_1;
    task_5_seq          seq_2;
    task_5_seq          seq_3;

    extern function new(string name = "task_5_vsequence");
    extern virtual task body();
    
endclass : task_5_vsequence

function task_5_vsequence::new(string name = "task_5_vsequence");
    super.new(name);
endfunction : new

task task_5_vsequence::body();
    seq_0 = new( "seq_0" );
    seq_1 = new( "seq_1" );
    seq_2 = new( "seq_2" );
    seq_3 = new( "seq_3" );

    if( seqr_0 == null )
        `uvm_fatal(this.get_name(), "seqr_0 is not set")

    seqr_0.set_arbitration(SEQ_ARB_WEIGHTED);
    seqr_0.set_arbitration(SEQ_ARB_STRICT_RANDOM);

    repeat(100)
    fork
        begin seq_0.start( seqr_0 , this , .this_priority(200) ); end
        begin seq_1.start( seqr_0 , this , .this_priority(400) ); end
        begin seq_2.start( seqr_0 , this , .this_priority(300) ); end
        begin seq_3.start( seqr_0 , this , .this_priority(200) ); end
    join
        
endtask : body

////////////////////////////////////////////////////////////////////
//  Class: task_5_test
//
class task_5_test extends uvm_test;

    task_5_sequencer    seqr_0;

    task_5_vsequence    vseq_0;

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
    
    vseq_0 = task_5_vsequence::type_id::create("vseq_0", this);

    vseq_0.seqr_0 = seqr_0;

endfunction : build_phase

task task_5_test::run_phase(uvm_phase phase);
    super.run_phase(phase);

    vseq_0.start(null);
    #200;
endtask : run_phase
////////////////////////////////////////////////////////////////////
//  Module: task_5
//
module task_5;

    initial begin
        run_test("task_5_test");
    end

endmodule : task_5
