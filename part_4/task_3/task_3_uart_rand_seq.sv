`ifndef UART_RAND_SEQ__SV
`define UART_RAND_SEQ__SV

import      uvm_pkg::*;
`include    "uvm_macros.svh"

import task_3_uart_pkg::*;

class uart_rand_seq extends uart_base_seq;
    `uvm_object_utils(uart_rand_seq)

    function new(string name = "uart_rand_seq");
        super.new(name);
    endfunction : new

    virtual task body();
        repeat(20)
        begin
            uart_item_ = uart_item::type_id::create("uart_item");
            uart_item_.randomize();
            start_item(uart_item_);
            finish_item(uart_item_);
        end
    endtask : body

endclass : uart_rand_seq

`endif // UART_RAND_SEQ__SV
