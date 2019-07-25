`ifndef APB_BASE_SEQ__SV
`define APB_BASE_SEQ__SV

class apb_base_seq extends uvm_sequence#(apb_item);

    apb_item item;

    function new(string name="apb_base_seq");
        super.new(name);
    endfunction : new

endclass : apb_base_seq

`endif // APB_BASE_SEQ__SV
