`ifndef APB_AGENT_CFG__SV
`define APB_AGENT_CFG__SV

//  Class: apb_agent_cfg
//
class apb_agent_cfg extends uvm_object;

    bit     [0 : 0]     is_master;
    bit     [0 : 0]     is_active;

    `uvm_object_utils_begin(apb_agent_cfg)
        `uvm_field_int( is_master , UVM_DEFAULT )
        `uvm_field_int( is_active , UVM_DEFAULT )
    `uvm_object_utils_end

    extern function      new(string name = "apb_agent_cfg");
    extern function void set_default();
    extern function void set_passive();
    extern function void set_master();
    extern function void set_slave();
    
endclass : apb_agent_cfg

function apb_agent_cfg::new(string name = "apb_agent_cfg");
    super.new(name);
endfunction: new

function void apb_agent_cfg::set_default();
    is_active = '0;
    is_master = '0;
endfunction : set_default

function void axi_agent_cfg::set_passive();
    is_active = '0;
endfunction : set_passive

function void axi_agent_cfg::set_master();
    is_active = '1;
    is_master = '1;
endfunction : set_master

function void axi_agent_cfg::set_slave();
    is_active = '1;
    is_master = '0;
endfunction : set_slave

`endif // APB_AGENT_CFG__SV
