`ifndef UART_SUBSCRIBER__SV
`define UART_SUBSCRIBER__SV

class uart_subscriber extends uvm_subscriber #(uart_item);
    `uvm_component_utils(uart_subscriber)
    
    extern function new (string name, uvm_component parent);
    extern function void write(uart_item t);

endclass : uart_subscriber

function uart_subscriber::new (string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void uart_subscriber::write(uart_item t);
    `uvm_info
                ( 
                    "UART|SUB", 
                    { "Receive item:\n" , t.convert2string() }, 
                    UVM_LOW 
                );
endfunction : write

`endif // UART_SUBSCRIBER__SV
