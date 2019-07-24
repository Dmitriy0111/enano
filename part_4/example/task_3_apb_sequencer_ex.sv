`ifndef APB_SEQUENCER__SV
`define APB_SEQUENCER__SV

import      uvm_pkg::*;
`include    "uvm_macros.svh"

import task_3_apb_pkg_ex::*;

class apb_sequencer extends uvm_sequencer #(apb_item);

    `uvm_component_utils(apb_sequencer)

    function new(input string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

endclass : apb_sequencer

`endif // APB_SEQUENCER__SV
