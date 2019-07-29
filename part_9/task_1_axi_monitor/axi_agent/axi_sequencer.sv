`ifndef AXI_SEQUENCER__SV
`define AXI_SEQUENCER__SV

class axi_sequencer extends uvm_sequencer #(axi_item);
    `uvm_component_utils(axi_sequencer)

    extern function new(string name, uvm_component parent = null);

endclass : axi_sequencer

function axi_sequencer::new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction : new

`endif // AXI_SEQUENCER__SV
