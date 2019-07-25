`ifndef UART_BASE_TEST__SV
`define UART_BASE_TEST__SV

class uart_base_test extends uvm_test;

    typedef virtual uart_if uart_vif;

    uart_env uart_env_;
    uart_vif uart_if_;

    `uvm_component_utils(uart_base_test)

    extern function new(string name, uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);

endclass : uart_base_test

function uart_base_test::new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void uart_base_test::build_phase(uvm_phase phase);
    uart_env_ = uart_env#()::type_id::create("uart_env_", this);
endfunction : build_phase

`endif // UART_BASE_TEST__SV
