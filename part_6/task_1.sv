import uvm_pkg::*;
`include "uvm_macros.svh"

//  Class: task_1_item
//
class task_1_item extends uvm_sequence_item;

    rand    integer     addr;
    rand    integer     data;

    typedef struct packed{
        integer     addr_0;
        integer     addr_1;
    } addr_;

    addr_               ban_addr[$];
    integer             ban_data[$];

    constraint data_c {
        data >= 0;
        data <= 255;
        foreach( ban_data[i] )
            data != ban_data[i];
    }

    constraint addr_c {
        addr >= 0;
        addr <= 255;
        foreach(ban_addr[i])
        {
            addr <= ban_addr[i].addr_0 || addr >= ban_addr[i].addr_1;
        }
    }

    `uvm_object_utils_begin(task_1_item)
        `uvm_field_int( addr , UVM_DEFAULT )
        `uvm_field_int( data , UVM_DEFAULT )
    `uvm_object_utils_end

    extern function new(string name = "task_1_item");
    extern task add_new_ban_data(integer ban_data);
    extern task add_new_ban_addr(integer addr_0, integer addr_1);
    extern task delete_ban_data();
    extern task delete_ban_addr();
    extern function string convert2string();
    extern task print_ban_data();
    
endclass : task_1_item

function task_1_item::new(string name = "task_1_item");
    super.new(name);
endfunction : new

task task_1_item::add_new_ban_data(integer ban_data);
    integer test_ban[$];
    test_ban = this.ban_data.find(x) with (x==ban_data);
    if(test_ban.size() == 0)
        this.ban_data.push_back( ban_data );
endtask : add_new_ban_data

task task_1_item::add_new_ban_addr(integer addr_0, integer addr_1);
    addr_ test_ban[$];
    test_ban = this.ban_addr.find(x) with ( (x.addr_0 == addr_0) && (x.addr_1 == addr_1) );
    if(test_ban.size() == 0)
        this.ban_addr.push_back( { addr_0 , addr_1 } );
endtask : add_new_ban_addr

task task_1_item::delete_ban_data();
    this.ban_data.delete();
endtask : delete_ban_data

task task_1_item::delete_ban_addr();
    this.ban_addr.delete();
endtask : delete_ban_addr

function string task_1_item::convert2string();
    string s;
    s = super.convert2string();
    $sformat(s, "%sADDR: <0x%h> ", s, addr);
    $sformat(s, "%sDATA: <0x%h>\n", s, data);
    return s;
endfunction: convert2string

task task_1_item::print_ban_data();
    foreach( this.ban_data[i] )
        $display("0x%h", ban_data[i]);
endtask : print_ban_data

module task_1;

    task_1_item     item = new();

    initial
    begin
        repeat(200)
            item.add_new_ban_data($urandom_range(0,100));
        item.print_ban_data();
        item.add_new_ban_addr(20,100);
        item.add_new_ban_addr(120,200);
        repeat(400)
        begin
            assert( item.randomize() ) else $stop;
            //item.print();
            $display(item.convert2string());
        end
        item.delete_ban_addr();
        item.delete_ban_data();
        $display("Random without ban data or addr");
        repeat(400)
        begin
            assert( item.randomize() ) else $stop;
            //item.print();
            $display(item.convert2string());
        end
        $stop;
    end

endmodule : task_1
