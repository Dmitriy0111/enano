`ifndef UART_RUN_ITEM_TEST__SV
`define UART_RUN_ITEM_TEST__SV

class uart_run_item_test extends uart_base_test;

    `uvm_component_utils( uart_run_item_test )

    uart_rand_seq seq0;

    extern function new(string name, uvm_component parent = null);
    extern task main_phase(uvm_phase phase);

endclass : uart_run_item_test

function uart_run_item_test::new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction : new

task uart_run_item_test::main_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info ("TB/TRACE/RUN_ITEM","start sequence", UVM_NONE)
    seq0 = uart_rand_seq::type_id::create("seq0");
    seq0.start(uart_env_.uart_agent_.uart_sqr);
    `uvm_info ("TB/TRACE/RUN_ITEM","finish sequence", UVM_NONE)
    #1000;
    phase.drop_objection(this);
endtask : main_phase

`endif // UART_RUN_ITEM_TEST__SV
