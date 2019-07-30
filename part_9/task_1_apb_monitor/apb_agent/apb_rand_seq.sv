`ifndef APB_RAND_SEQ__SV
`define APB_RAND_SEQ__SV

class apb_rand_seq extends apb_base_seq;
    `uvm_object_utils(apb_rand_seq)

    extern function new(string name = "apb_rand_seq");
    extern virtual task body();

endclass : apb_rand_seq

function apb_rand_seq::new(string name = "apb_rand_seq");
    super.new(name);
endfunction : new

task apb_rand_seq::body();
    repeat(100)
    begin
        apb_item_ = apb_item::type_id::create("apb_item");
        apb_item_.randomize();
        start_item(apb_item_);
        finish_item(apb_item_);
    end
endtask : body

`endif // APB_RAND_SEQ__SV
