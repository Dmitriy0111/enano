`ifndef UART_BASE_SEQ__SV
`define UART_BASE_SEQ__SV

import      uvm_pkg::*;
`include    "uvm_macros.svh"

import task_3_uart_pkg::*;

class uart_base_seq extends uvm_sequence #(uart_item);

    uart_item   uart_item_;

    function new(string name = "uart_base_seq");
        super.new(name);
    endfunction : new

endclass : uart_base_seq

`endif // UART_BASE_SEQ__SV
