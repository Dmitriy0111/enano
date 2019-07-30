`ifndef AHB_BASE_SEQ__SV
`define AHB_BASE_SEQ__SV

class ahb_base_seq extends uvm_sequence #(ahb_item);

    ahb_item    ahb_item_;

    extern function new(string name = "ahb_base_seq");

endclass : ahb_base_seq

function ahb_base_seq::new(string name = "ahb_base_seq");
    super.new(name);
endfunction : new

`endif // AHB_BASE_SEQ__SV
