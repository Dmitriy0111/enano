import uvm_pkg::*;
`include "uvm_macros.svh"

////////////////////////////////////////////////////////////////////
//  Class: task_7_item
//
class task_7_item extends uvm_sequence_item;

    rand    integer     addr;

    `uvm_object_utils_begin(task_7_item)
        `uvm_field_int( addr , UVM_DEFAULT )
    `uvm_object_utils_end

    extern function new(string name = "task_7_item");
    extern function string convert2string();
    
endclass : task_7_item

function task_7_item::new(string name = "task_7_item");
    super.new(name);
endfunction : new

function string task_7_item::convert2string();
    string s;
    s = super.convert2string();
    $sformat(s, "%sADDR: <0x%h> ", s, addr);
    return s;
endfunction : convert2string
////////////////////////////////////////////////////////////////////
//  Class: task_7_base_seq
//
class task_7_base_seq extends uvm_sequence#(task_7_item);

    task_7_item item;

    `uvm_object_utils_begin(task_7_base_seq)
        `uvm_field_object(item, UVM_ALL_ON | UVM_NOPACK);
    `uvm_object_utils_end

    extern function new(string name="task_7_base_seq");

endclass : task_7_base_seq

function task_7_base_seq::new(string name="task_7_base_seq");
    super.new(name);
endfunction
////////////////////////////////////////////////////////////////////
//  Class: task_7_seq
//
class task_7_seq extends task_7_base_seq;
    `uvm_object_utils(task_7_seq)

    extern function new(string name="task_7_seq");
    extern virtual task body();

endclass : task_7_seq

function task_7_seq::new(string name="task_7_seq");
    super.new(name);
endfunction : new

task task_7_seq::body();
    item = task_7_item::type_id::create("item");
    item.randomize();
    `uvm_info(this.get_name() ,item.convert2string(), UVM_LOW);
endtask : body
////////////////////////////////////////////////////////////////////
//  Class: task_7_sequencer
//
class task_7_sequencer extends uvm_sequencer #(task_7_item);
    `uvm_component_utils(task_7_sequencer)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

endclass : task_7_sequencer
////////////////////////////////////////////////////////////////////
//  Class: task_7_test
//
class task_7_test extends uvm_test;

    task_7_sequencer        seqr_0;
    task_7_seq              seq_0;
    task_7_seq              seq_1;
    uvm_cmdline_processor   opts;
    string                  argv[$];

    `uvm_component_utils(task_7_test)

    extern function new(string name, uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);

endclass : task_7_test

function task_7_test::new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void task_7_test::build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    opts = uvm_cmdline_processor::get_inst();
    opts.get_args(argv);
    foreach( argv[i] )
        $display(argv[i]);
    seqr_0 = task_7_sequencer::type_id::create("seqr_0",this);
    
    seq_0 = task_7_seq::type_id::create("seq_0", this);
    
    seq_1 = task_7_seq::type_id::create("seq_1", this);

endfunction : build_phase

task task_7_test::run_phase(uvm_phase phase);
    super.run_phase(phase);
    case( argv[$] )
        "+seq_0"    : 
                    begin
                        `uvm_info(this.get_name(), { "Enabled sequence is " , argv[$].substr(1,argv.size()+1) }, UVM_LOW)
                        repeat(100)
                            seq_0.start( seqr_0 );
                    end
        "+seq_1"    : 
                    begin
                        `uvm_info(this.get_name(), { "Enabled sequence is " , argv[$].substr(1,argv.size()+1) }, UVM_LOW)
                        repeat(100)
                            seq_1.start( seqr_0 );
                    end
        default     : 
                    begin
                        `uvm_fatal(this.get_name(), "Undefined sequence");
                        $stop;
                    end
    endcase
    repeat(100)
        case(argv[$])
            "+seq_0"    : seq_0.start( seqr_0 );
            "+seq_1"    : seq_1.start( seqr_0 );
            default     : $stop;
        endcase
    #200;
endtask : run_phase
////////////////////////////////////////////////////////////////////
//  Module: task_7
//
module task_7;

    initial begin
        run_test("task_7_test");
    end

endmodule : task_7
