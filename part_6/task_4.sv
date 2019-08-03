import uvm_pkg::*;
`include "uvm_macros.svh"

////////////////////////////////////////////////////////////////////
//  Class: task_4_item
//
class task_4_item extends uvm_sequence_item;

    rand    integer     addr;

    `uvm_object_utils_begin(task_4_item)
        `uvm_field_int( addr , UVM_DEFAULT )
    `uvm_object_utils_end

    extern function new(string name = "task_4_item");
    extern function string convert2string();
    
endclass : task_4_item

function task_4_item::new(string name = "task_4_item");
    super.new(name);
endfunction : new

function string task_4_item::convert2string();
    string s;
    s = super.convert2string();
    $sformat(s, "%sADDR: <%d> ", s, addr);
    return s;
endfunction : convert2string
////////////////////////////////////////////////////////////////////
//  Class: task_4_base_seq
//
class task_4_base_seq extends uvm_sequence#(task_4_item);

    task_4_item item;

    `uvm_object_utils_begin(task_4_base_seq)
        `uvm_field_object(item, UVM_ALL_ON | UVM_NOPACK );
    `uvm_object_utils_end

    extern function new(string name="task_4_base_seq");

endclass : task_4_base_seq

function task_4_base_seq::new(string name="task_4_base_seq");
    super.new(name);
endfunction
////////////////////////////////////////////////////////////////////
//  Class: task_4_seq
//
class task_4_seq extends task_4_base_seq;
    `uvm_object_utils(task_4_seq)

    typedef struct packed{
        integer     addr_0;
        integer     addr_1;
        integer     freq;
    } addr_pack;

    integer freq_sum = 0;

    addr_pack   addr_i[$] = '{ 
                                '{ 10  , 20  , 5  },
                                '{ 30  , 40  , 10 }, 
                                '{ 50  , 60  , 20 }, 
                                '{ 70  , 80  , 30 },
                                '{ 90  , 100 , 20 },
                                '{ 110 , 120 , 10 }, 
                                '{ 130 , 140 , 5  } 
                            };

    extern function new(string name="task_4_seq");
    extern virtual task edit_addr();
    extern virtual task body();
    extern function int dist_with_freqs();

endclass : task_4_seq

function task_4_seq::new(string name="task_4_seq");
    super.new(name);
endfunction : new

task task_4_seq::edit_addr();
    freq_sum = 0;
    foreach(addr_i[i])
        freq_sum += addr_i[i].freq;
    repeat(200)
    begin
        integer i;
        item = task_4_item::type_id::create("item");
        i = dist_with_freqs();
        item.randomize() with   { 
                                    addr inside { [ addr_i[i].addr_0 : addr_i[i].addr_1 ] }; 
                                };
        // start_item(item);
        // finish_item(item);
        $display(item.convert2string());
    end
endtask : edit_addr

function int task_4_seq::dist_with_freqs();
    integer rand_v;
    integer rand_i;
    rand_v = $urandom_range(freq_sum-1);
    $display("rand_v = %d",rand_v);
    for( rand_i = 0 ; rand_i < addr_i.size() ; rand_i++ )
    begin
        if( rand_v <= addr_i[rand_i].freq )
        begin
            $display("rand_i = %d", rand_i);
            return rand_i;
        end
        rand_v -= addr_i[rand_i].freq;
    end
    return 0;
endfunction : dist_with_freqs

task task_4_seq::body();
    edit_addr();
endtask : body
////////////////////////////////////////////////////////////////////
//  Class: task_4_sequencer
//
class task_4_sequencer extends uvm_sequencer #(task_4_item);
    `uvm_component_utils(task_4_sequencer)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

endclass : task_4_sequencer
////////////////////////////////////////////////////////////////////
//  Class: task_4_test
//
class task_4_test extends uvm_test;

    task_4_sequencer seqr;
    task_4_seq task_4_seq_;

    `uvm_component_utils(task_4_test)

    extern function new(string name, uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);

endclass : task_4_test

function task_4_test::new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void task_4_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    seqr = task_4_sequencer::type_id::create("seqr",this);
    task_4_seq_ = task_4_seq::type_id::create("task_4_seq_", this);
endfunction : build_phase

task task_4_test::run_phase(uvm_phase phase);
    super.run_phase(phase);
    task_4_seq_.start(seqr);
    #200;
endtask : run_phase
////////////////////////////////////////////////////////////////////
//  Module: task_4
//
module task_4;

    initial begin
        run_test("task_4_test");
    end

endmodule : task_4
