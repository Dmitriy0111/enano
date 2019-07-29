`ifndef AXI_AGENT_CFG__SV
`define AXI_AGENT_CFG__SV

//  Class: axi_agent_cfg
//
class axi_agent_cfg extends uvm_object;

    bit     [0 : 0]     is_master;
    bit     [0 : 0]     is_active;

    `uvm_object_utils_begin(axi_agent_cfg);
        `uvm_field_int( is_master , UVM_DEFAULT )
        `uvm_field_int( is_active , UVM_DEFAULT )
    `uvm_object_utils_end

    extern function new(string name = "axi_agent_cfg");
    extern function void set_default();
    
endclass : axi_agent_cfg

function axi_agent_cfg::new(string name = "axi_agent_cfg");
    super.new(name);
endfunction: new

function void axi_agent_cfg::set_default();
    is_active = '1;
    is_master = '1;
endfunction : set_default

`endif // AXI_AGENT_CFG__SV
