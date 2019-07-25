`ifndef UART_SEQUENCER__SV
`define UART_SEQUENCER__SV

class uart_sequencer extends uvm_sequencer #(uart_item);
    `uvm_component_utils(uart_sequencer)

    extern function new(string name, uvm_component parent = null);

endclass : uart_sequencer

function uart_sequencer::new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction : new

`endif // UART_SEQUENCER__SV
