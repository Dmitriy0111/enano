`ifndef APB_RAND_SEQ__SV
`define APB_RAND_SEQ__SV

import      uvm_pkg::*;
`include    "uvm_macros.svh"

import task_3_apb_pkg_ex::*;

class apb_rand_seq extends apb_base_seq;

    `uvm_object_utils(apb_rand_seq)

    function new(string name="apb_rand_seq");
        super.new(name);
    endfunction : new

    virtual task body();
        repeat (20) 
        begin
            item = apb_item::type_id::create("item");
            item.randomize();
            start_item(item);
            finish_item(item);
            //`uvm_do(req)
        end
    endtask : body

endclass : apb_rand_seq

`endif // APB_RAND_SEQ__SV
