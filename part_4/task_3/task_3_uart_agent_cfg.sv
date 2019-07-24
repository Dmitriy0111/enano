`ifndef UART_AGENT_CFG__SV
`define UART_AGENT_CFG__SV

import      uvm_pkg::*;
`include    "uvm_macros.svh"

import task_3_uart_pkg::*;

class uart_agent_cfg extends uvm_object;

    typedef virtual uart_if uart_vif;
    
    bit     is_active = '1;
    bit     master    = '1;

    uart_vif uart_if_;

    `uvm_object_utils_begin(uart_agent_cfg)
        `uvm_field_int( is_active , UVM_ALL_ON | UVM_NOPACK );
        `uvm_field_int( master    , UVM_ALL_ON | UVM_NOPACK );
    `uvm_object_utils_end

    function new(string name = "uart_agent_cfg");
        super.new(name);
    endfunction : new

    function void set_default();
        is_active = '1;
        master = '1;
    endfunction : set_default

endclass : uart_agent_cfg

`endif // UART_AGENT_CFG__SV
