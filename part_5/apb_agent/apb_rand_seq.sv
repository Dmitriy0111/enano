`ifndef APB_RAND_SEQ__SV
`define APB_RAND_SEQ__SV

//  Class: apb_rand_seq
//
class apb_rand_seq extends apb_base_seq;

    `uvm_object_utils(apb_rand_seq);

    extern function new(string name = "apb_rand_seq");
    extern virtual task body();
    
endclass: apb_rand_seq

function apb_rand_seq::new(string name = "apb_rand_seq");
    super.new(name);
endfunction : new

task apb_rand_seq::body();
    repeat(20)
    begin
        item = apb_item#()::type_id::create("item");
        item.randomize();
        start_item(item);
        finish_item(item);
    end
endtask : body

`endif // APB_RAND_SEQ__SV
