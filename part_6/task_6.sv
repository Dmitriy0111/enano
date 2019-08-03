import uvm_pkg::*;
`include "uvm_macros.svh"

////////////////////////////////////////////////////////////////////
//  Class: task_6_item
//
class task_6_item extends uvm_sequence_item;

    rand    integer     addr;
    rand    integer     data;

    `uvm_object_utils_begin(task_6_item)
        `uvm_field_int( addr , UVM_DEFAULT )
        `uvm_field_int( data , UVM_DEFAULT )
    `uvm_object_utils_end

    extern function new(string name = "task_6_item");
    extern function string convert2string();
    
endclass : task_6_item

function task_6_item::new(string name = "task_6_item");
    super.new(name);
endfunction : new

function string task_6_item::convert2string();
    string s;
    s = super.convert2string();
    $sformat(s, "%sADDR: <0x%h> ", s, addr);
    $sformat(s, "%sDATA: <0x%h> ", s, data);
    return s;
endfunction : convert2string
////////////////////////////////////////////////////////////////////
//  Class: task_6_base_seq
//
class task_6_base_seq extends uvm_sequence#(task_6_item);

    task_6_item item;

    `uvm_object_utils_begin(task_6_base_seq)
        `uvm_field_object(item, UVM_ALL_ON | UVM_NOPACK);
    `uvm_object_utils_end

    extern function new(string name="task_6_base_seq");

endclass : task_6_base_seq

function task_6_base_seq::new(string name="task_6_base_seq");
    super.new(name);
endfunction
////////////////////////////////////////////////////////////////////
//  Class: task_6_0_seq
//
class task_6_0_seq extends task_6_base_seq;
    `uvm_object_utils(task_6_0_seq)

    extern function new(string name="task_6_0_seq");
    extern virtual task body();

endclass : task_6_0_seq

function task_6_0_seq::new(string name="task_6_0_seq");
    super.new(name);
endfunction : new

task task_6_0_seq::body();
    item = task_6_item::type_id::create("item");
    repeat(20)
    begin
        assert( item.randomize() ) else $stop;
        `uvm_info(this.get_name() ,item.convert2string(), UVM_LOW);
    end
endtask : body
////////////////////////////////////////////////////////////////////
//  Class: task_6_1_seq
//
class task_6_1_seq extends task_6_base_seq;
    `uvm_object_utils(task_6_1_seq)

    integer addr_0 = $urandom_range(0,127);
    integer addr_1 = $urandom_range(128,255);

    extern function new(string name="task_6_1_seq");
    extern virtual task body();

endclass : task_6_1_seq

function task_6_1_seq::new(string name="task_6_1_seq");
    super.new(name);
endfunction : new

task task_6_1_seq::body();
    item = task_6_item::type_id::create("item");
    repeat(20)
    begin
        assert( item.randomize() with { addr >= addr_0; addr <= addr_1; data <= 255 ; data >= 0; } ) else $stop;
        `uvm_info(this.get_name() ,item.convert2string(), UVM_LOW);
    end
endtask : body
////////////////////////////////////////////////////////////////////
//  Class: task_6_2_seq
//
class task_6_2_seq extends task_6_base_seq;
    `uvm_object_utils(task_6_2_seq)

    integer data_0 = $urandom_range(0,127);
    integer data_1 = $urandom_range(128,255);

    extern function new(string name="task_6_2_seq");
    extern virtual task body();

endclass : task_6_2_seq

function task_6_2_seq::new(string name="task_6_2_seq");
    super.new(name);
endfunction : new

task task_6_2_seq::body();
    item = task_6_item::type_id::create("item");
    repeat(20)
    begin
        assert( item.randomize() with { addr >= 0; addr <= 255; data >= data_0 ; data <= data_1; } ) else $stop;
        `uvm_info(this.get_name() ,item.convert2string(), UVM_LOW);
    end
endtask : body

////////////////////////////////////////////////////////////////////
//  Class: task_6_3_seq
//
class task_6_3_seq extends task_6_base_seq;
    `uvm_object_utils(task_6_3_seq)

    typedef struct packed{
        integer     addr_0;
        integer     addr_1;
        integer     freq;
    } addr_i;

    addr_i  addr_i_ [$]= 
                        '{ 
                            '{ $urandom_range( 10  ,  20 ) , $urandom_range( 20  ,  30 ) , $urandom_range( 10 , 20 ) },
                            '{ $urandom_range( 40  ,  60 ) , $urandom_range( 60  ,  70 ) , $urandom_range( 10 , 20 ) },
                            '{ $urandom_range( 80  ,  90 ) , $urandom_range( 90  , 110 ) , $urandom_range( 10 , 20 ) },
                            '{ $urandom_range( 120 , 140 ) , $urandom_range( 140 , 160 ) , $urandom_range( 10 , 20 ) },
                            '{ $urandom_range( 170 , 175 ) , $urandom_range( 175 , 180 ) , $urandom_range( 10 , 20 ) }
                        };

    integer freq_sum;

    extern function new(string name="task_6_3_seq");
    extern function integer find_addr_i();
    extern virtual task body();

endclass : task_6_3_seq

function task_6_3_seq::new(string name="task_6_3_seq");
    super.new(name);
endfunction : new

function integer task_6_3_seq::find_addr_i();
    integer rand_v;
    rand_v = $urandom_range(freq_sum);
    for( integer i = 0 ; i < addr_i_.size() ; i++ )
    begin
        if( rand_v < addr_i_[i].freq )
            return i;
        rand_v -= addr_i_[i].freq;
    end
    return 0;
endfunction : find_addr_i

task task_6_3_seq::body();
    freq_sum = 0;
    foreach( addr_i_[i] )
        freq_sum += addr_i_[i].freq;
    repeat(20)
    begin
        integer rand_i;
        rand_i = find_addr_i();
        item = task_6_item::type_id::create("item");
        assert( item.randomize() with { addr inside { [ addr_i_[rand_i].addr_0 : addr_i_[rand_i].addr_1 ] }; data inside { [10:20] , [100:110] , [210:220] }; } ) else $stop;
        `uvm_info(this.get_name() ,item.convert2string(), UVM_LOW);
    end
endtask : body

////////////////////////////////////////////////////////////////////
//  Class: task_6_4_seq
//
class task_6_4_seq extends task_6_base_seq;
    `uvm_object_utils(task_6_4_seq)

    typedef struct packed{
        integer     data_0;
        integer     data_1;
        integer     freq;
    } data_i;

    data_i  data_i_ [$]= 
                        '{ 
                            '{ $urandom_range( 10  ,  20 ) , $urandom_range( 20  ,  30 ) , $urandom_range( 10 , 20 ) },
                            '{ $urandom_range( 40  ,  60 ) , $urandom_range( 60  ,  70 ) , $urandom_range( 10 , 20 ) },
                            '{ $urandom_range( 80  ,  90 ) , $urandom_range( 90  , 110 ) , $urandom_range( 10 , 20 ) },
                            '{ $urandom_range( 120 , 140 ) , $urandom_range( 140 , 160 ) , $urandom_range( 10 , 20 ) },
                            '{ $urandom_range( 170 , 175 ) , $urandom_range( 175 , 180 ) , $urandom_range( 10 , 20 ) }
                        };

    integer freq_sum;

    extern function new(string name="task_6_4_seq");
    extern function integer find_data_i();
    extern virtual task body();

endclass : task_6_4_seq

function task_6_4_seq::new(string name="task_6_4_seq");
    super.new(name);
endfunction : new

function integer task_6_4_seq::find_data_i();
    integer rand_v;
    rand_v = $urandom_range(freq_sum);
    for( integer i = 0 ; i < data_i_.size() ; i++ )
    begin
        if( rand_v < data_i_[i].freq )
            return i;
        rand_v -= data_i_[i].freq;
    end
    return 0;
endfunction : find_data_i

task task_6_4_seq::body();
    freq_sum = 0;
    foreach( data_i_[i] )
        freq_sum += data_i_[i].freq;
    repeat(20)
    begin
        integer rand_i;
        rand_i = find_data_i();
        item = task_6_item::type_id::create("item");
        assert( item.randomize() with { data inside { [ data_i_[rand_i].data_0 : data_i_[rand_i].data_1 ] }; addr dist { [10:30] :/ 10 , [40:50] :/ 30 , [60:80] :/ 10 }; } ) else $stop;
        `uvm_info(this.get_name() ,item.convert2string(), UVM_LOW);
    end
endtask : body
////////////////////////////////////////////////////////////////////
//  Class: task_6_sequencer
//
class task_6_sequencer extends uvm_sequencer #(task_6_item);
    `uvm_component_utils(task_6_sequencer)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

endclass : task_6_sequencer
////////////////////////////////////////////////////////////////////
//  Class: task_6_vsequence
//
class task_6_vsequence extends uvm_sequence;
    `uvm_object_utils(task_6_vsequence);

    task_6_base_seq     seq_0_p;

    task_6_0_seq        task_6_0_seq_0;
    task_6_0_seq        task_6_0_seq_1;
    task_6_1_seq        task_6_1_seq_0;
    task_6_1_seq        task_6_1_seq_1;
    task_6_2_seq        task_6_2_seq_0;
    task_6_2_seq        task_6_2_seq_1;
    task_6_3_seq        task_6_3_seq_0;
    task_6_3_seq        task_6_3_seq_1;
    task_6_4_seq        task_6_4_seq_0;
    task_6_4_seq        task_6_4_seq_1;

    task_6_sequencer    seqr_p;

    task_6_sequencer    seqr_0_p;
    task_6_sequencer    seqr_1_p;
    task_6_sequencer    seqr_2_p;
    task_6_sequencer    seqr_3_p;
    task_6_sequencer    seqr_4_p;

    extern function new(string name = "task_6_vsequence");

    extern virtual task body();
   
endclass : task_6_vsequence

function task_6_vsequence::new(string name = "task_6_vsequence");
    super.new(name);
endfunction : new

task task_6_vsequence::body();

    seq_0_p        = new( "seq_0_p"        );

    task_6_0_seq_0 = new( "task_6_0_seq_0" );
    task_6_0_seq_1 = new( "task_6_0_seq_1" );
    task_6_1_seq_0 = new( "task_6_1_seq_0" );
    task_6_1_seq_1 = new( "task_6_1_seq_1" );
    task_6_2_seq_0 = new( "task_6_2_seq_0" );
    task_6_2_seq_1 = new( "task_6_2_seq_1" );
    task_6_3_seq_0 = new( "task_6_3_seq_0" );
    task_6_3_seq_1 = new( "task_6_3_seq_1" );
    task_6_4_seq_0 = new( "task_6_4_seq_0" );
    task_6_4_seq_1 = new( "task_6_4_seq_1" );

    if( seqr_0_p == null ) 
        `uvm_fatal(this.get_name(),"seqr_0_p is not set")
    if( seqr_1_p == null ) 
        `uvm_fatal(this.get_name(),"seqr_1_p is not set")
    if( seqr_2_p == null ) 
        `uvm_fatal(this.get_name(),"seqr_2_p is not set")
    if( seqr_3_p == null ) 
        `uvm_fatal(this.get_name(),"seqr_3_p is not set")
    if( seqr_4_p == null ) 
        `uvm_fatal(this.get_name(),"seqr_4_p is not set")

    case( $urandom_range(0,9) )
        0       : seq_0_p = task_6_0_seq_0;
        1       : seq_0_p = task_6_0_seq_1;
        2       : seq_0_p = task_6_1_seq_0;
        3       : seq_0_p = task_6_1_seq_1;
        4       : seq_0_p = task_6_2_seq_0;
        5       : seq_0_p = task_6_2_seq_1;
        6       : seq_0_p = task_6_3_seq_0;
        7       : seq_0_p = task_6_3_seq_1;
        8       : seq_0_p = task_6_4_seq_0;
        9       : seq_0_p = task_6_4_seq_1;
        default : seq_0_p = task_6_0_seq_0;
    endcase

    repeat(2)
    begin
        case( $urandom_range(0,3) )
            0       : seqr_p = seqr_0_p;
            1       : seqr_p = seqr_1_p;
            2       : seqr_p = seqr_2_p;
            3       : seqr_p = seqr_3_p;
            3       : seqr_p = seqr_4_p;
            default : seqr_p = seqr_0_p;
        endcase
        $display("Sequence %s start on sequencer %s", seq_0_p.get_name(), seqr_p.get_name() );
        seq_0_p.start( seqr_p );
    end

endtask : body
////////////////////////////////////////////////////////////////////
//  Class: task_6_test
//
class task_6_test extends uvm_test;

    task_6_vsequence    vseq_0;

    task_6_sequencer    seqr_0;
    task_6_sequencer    seqr_1;
    task_6_sequencer    seqr_2;
    task_6_sequencer    seqr_3;
    task_6_sequencer    seqr_4;

    `uvm_component_utils(task_6_test)

    extern function new(string name, uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);

endclass : task_6_test

function task_6_test::new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void task_6_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    vseq_0 = task_6_vsequence::type_id::create("vseq_0", this);
    seqr_0 = task_6_sequencer::type_id::create("seqr_0", this);
    seqr_1 = task_6_sequencer::type_id::create("seqr_1", this);
    seqr_2 = task_6_sequencer::type_id::create("seqr_2", this);
    seqr_3 = task_6_sequencer::type_id::create("seqr_3", this);
    seqr_4 = task_6_sequencer::type_id::create("seqr_4", this);

    vseq_0.seqr_0_p = seqr_0;
    vseq_0.seqr_1_p = seqr_1;
    vseq_0.seqr_2_p = seqr_2;
    vseq_0.seqr_3_p = seqr_3;
    vseq_0.seqr_4_p = seqr_4;

endfunction : build_phase

task task_6_test::run_phase(uvm_phase phase);
    super.run_phase(phase);
    repeat(100)
        vseq_0.start(null);
    #200;
endtask : run_phase
////////////////////////////////////////////////////////////////////
//  Module: task_6
//
module task_6;

    initial begin
        run_test("task_6_test");
    end

endmodule : task_6
