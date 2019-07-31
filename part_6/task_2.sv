//  Class: task_2_item
//
class task_2_item extends uvm_sequence_item;

    rand    integer     addr;
    rand    integer     data;

    `uvm_object_utils_begin(task_2_item)
        `uvm_field_int( addr , UVM_DEFAULT | UVM_NOCOMPARE )
        `uvm_field_int( data , UVM_DEFAULT | UVM_NOCOMPARE )
    `uvm_object_utils_end

    extern function new(string name = "task_2_item");
    
endclass: task_2_item

function task_2_item::new(string name = "task_2_item");
    super.new(name);
endfunction : new
