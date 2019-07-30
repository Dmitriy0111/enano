`ifndef AHB_SEQUENCER__SV
`define AHB_SEQUENCER__SV

class ahb_sequencer extends uvm_sequencer #(ahb_item);
    `uvm_component_utils(ahb_sequencer)

    extern function new(string name, uvm_component parent = null);

endclass : ahb_sequencer

function ahb_sequencer::new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction : new

`endif // AHB_SEQUENCER__SV
