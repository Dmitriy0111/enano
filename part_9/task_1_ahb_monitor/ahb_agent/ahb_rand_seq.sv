`ifndef AHB_RAND_SEQ__SV
`define AHB_RAND_SEQ__SV

class ahb_rand_seq extends ahb_base_seq;
    `uvm_object_utils(ahb_rand_seq)

    extern function new(string name = "ahb_rand_seq");
    extern virtual task body();

endclass : ahb_rand_seq

function ahb_rand_seq::new(string name = "ahb_rand_seq");
    super.new(name);
endfunction : new

task ahb_rand_seq::body();
    repeat(100)
    begin
        ahb_item_ = ahb_item::type_id::create("ahb_item");
        ahb_item_.randomize();
        start_item(ahb_item_);
        finish_item(ahb_item_);
    end
endtask : body

`endif // AHB_RAND_SEQ__SV
