`ifndef APB_SEQUENCER__SV
`define APB_SEQUENCER__SV

//  Class: apb_sequencer
//
class apb_sequencer extends uvm_sequencer#(apb_item);
    `uvm_component_utils(apb_sequencer);

    extern function new(string name = "apb_sequencer", uvm_component parent = null);
    
endclass : apb_sequencer

function apb_sequencer::new(string name = "apb_sequencer", uvm_component parent = null);
    super.new(name, parent);
endfunction : new

`endif // APB_SEQUENCER__SV
