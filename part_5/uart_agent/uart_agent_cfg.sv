//  Class: uart_agent_cfg
//
`ifndef UART_AGENT_CFG__SV
`define UART_AGENT_CFG__SV

class uart_agent_cfg extends uvm_object;

    uvm_active_passive_enum is_active;
    bit     [0 : 0]         master;
    int                     intf_id;

    `uvm_object_utils_begin(uart_agent_cfg)
        `uvm_field_enum ( uvm_active_passive_enum , is_active , UVM_DEFAULT );
        `uvm_field_int  ( master                              , UVM_DEFAULT );
        `uvm_field_int  ( intf_id                             , UVM_DEFAULT );
    `uvm_object_utils_end
    
    extern function new(string name = "uart_agent_cfg");
    extern function void set_default();
    
endclass : uart_agent_cfg

function uart_agent_cfg::new(string name = "uart_agent_cfg");
    super.new(name);
endfunction : new

function void uart_agent_cfg::set_default();
    is_active   = UVM_ACTIVE;
    master      = '1;
    intf_id     = 1;
endfunction : set_default

`endif // UART_AGENT_CFG__SV
