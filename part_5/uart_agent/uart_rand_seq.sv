`ifndef UART_RAND_SEQ__SV
`define UART_RAND_SEQ__SV

class uart_rand_seq extends uart_base_seq;
    `uvm_object_utils(uart_rand_seq)

    extern function new(string name = "uart_rand_seq");
    extern virtual task body();

endclass : uart_rand_seq

function uart_rand_seq::new(string name = "uart_rand_seq");
    super.new(name);
endfunction : new

task uart_rand_seq::body();
    repeat(100)
    begin
        uart_item_ = uart_item::type_id::create("uart_item");
        uart_item_.randomize();
        start_item(uart_item_);
        finish_item(uart_item_);
    end
endtask : body

`endif // UART_RAND_SEQ__SV
