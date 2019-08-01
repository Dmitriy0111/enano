import uvm_pkg::*;
`include "uvm_macros.svh"

//  Class: task_2_item
//
class task_2_item extends uvm_sequence_item;

    rand    integer     addr;
    rand    integer     data_0;
    rand    integer     data_1;
    rand    integer     data_2;
    rand    integer     data_3;
    rand    integer     data_4;
    rand    integer     data_5;

    `uvm_object_utils_begin(task_2_item)
        `uvm_field_int( addr   , UVM_DEFAULT                 )
        `uvm_field_int( data_0 , UVM_DEFAULT | UVM_NOCOMPARE )
        `uvm_field_int( data_1 , UVM_DEFAULT                 )
        `uvm_field_int( data_2 , UVM_DEFAULT | UVM_NOCOMPARE )
        `uvm_field_int( data_3 , UVM_DEFAULT                 )
        `uvm_field_int( data_4 , UVM_DEFAULT | UVM_NOCOMPARE )
        `uvm_field_int( data_5 , UVM_DEFAULT                 )
    `uvm_object_utils_end

    extern function new(string name = "task_2_item");
    
endclass : task_2_item

function task_2_item::new(string name = "task_2_item");
    super.new(name);
endfunction : new

module task_2;

    task_2_item     item_0 = new("item_0");
    task_2_item     item_1 = new("item_1");

    initial
    begin
        repeat(400)
        begin
            item_0.randomize();
            item_1.copy(item_0);
            repeat($urandom_range(0,7))
                case($urandom_range(0,6))
                    0       :   begin item_1.addr   = $random(); $display("New addr   = 0x%h", item_1.addr  ); end
                    1       :   begin item_1.data_0 = $random(); $display("New data_0 = 0x%h", item_1.data_0); end
                    2       :   begin item_1.data_1 = $random(); $display("New data_1 = 0x%h", item_1.data_1); end
                    3       :   begin item_1.data_2 = $random(); $display("New data_2 = 0x%h", item_1.data_2); end
                    4       :   begin item_1.data_3 = $random(); $display("New data_3 = 0x%h", item_1.data_3); end
                    5       :   begin item_1.data_4 = $random(); $display("New data_4 = 0x%h", item_1.data_4); end
                    6       :   begin item_1.data_5 = $random(); $display("New data_5 = 0x%h", item_1.data_5); end
                endcase
            item_0.print();
            item_1.print();
            if( item_0.compare(item_1) )
                $display("Transactors is equal");
            else
                $display("Transactors is not equal");
        end
        $stop;
    end

endmodule : task_2
