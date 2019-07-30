`ifndef APB_BASE_SEQ__SV
`define APB_BASE_SEQ__SV

class apb_base_seq extends uvm_sequence #(apb_item);

    apb_item    apb_item_;

    extern function new(string name = "apb_base_seq");

endclass : apb_base_seq

function apb_base_seq::new(string name = "apb_base_seq");
    super.new(name);
endfunction : new

`endif // APB_BASE_SEQ__SV
