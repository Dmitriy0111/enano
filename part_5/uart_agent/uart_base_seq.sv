`ifndef UART_BASE_SEQ__SV
`define UART_BASE_SEQ__SV

class uart_base_seq extends uvm_sequence #(uart_item);

    uart_item   uart_item_;

    extern function new(string name = "uart_base_seq");

endclass : uart_base_seq

function uart_base_seq::new(string name = "uart_base_seq");
    super.new(name);
endfunction : new

`endif // UART_BASE_SEQ__SV
