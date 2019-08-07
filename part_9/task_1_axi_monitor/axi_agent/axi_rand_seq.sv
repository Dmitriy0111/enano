`ifndef AXI_RAND_SEQ__SV
`define AXI_RAND_SEQ__SV

class axi_rand_seq extends axi_base_seq;
    `uvm_object_utils(axi_rand_seq)

    extern         function new(string name = "axi_rand_seq");
    extern virtual task     body();

endclass : axi_rand_seq

function axi_rand_seq::new(string name = "axi_rand_seq");
    super.new(name);
endfunction : new

task axi_rand_seq::body();
    repeat(30)
    begin
        axi_item_ = axi_item::type_id::create("axi_item");
        axi_item_.randomize();
        start_item(axi_item_);
        finish_item(axi_item_);
    end
endtask : body

`endif // AXI_RAND_SEQ__SV
