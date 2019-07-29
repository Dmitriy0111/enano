`ifndef AXI_BASE_SEQ__SV
`define AXI_BASE_SEQ__SV

class axi_base_seq extends uvm_sequence #(axi_item);

    axi_item    axi_item_;

    extern function new(string name = "axi_base_seq");

endclass : axi_base_seq

function axi_base_seq::new(string name = "axi_base_seq");
    super.new(name);
endfunction : new

`endif // AXI_BASE_SEQ__SV
