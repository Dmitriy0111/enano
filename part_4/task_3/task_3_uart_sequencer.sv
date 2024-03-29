`ifndef UART_SEQUENCER__SV
`define UART_SEQUENCER__SV

class uart_sequencer extends uvm_sequencer #(uart_item);
    `uvm_component_utils(uart_sequencer)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

endclass : uart_sequencer

`endif // UART_SEQUENCER__SV
