`ifndef APB_AGENT_CFG__SV
`define APB_AGENT_CFG__SV

class apb_agent_cfg extends uvm_object;

    bit     [0 : 0]     is_active = 1;
    bit     [0 : 0]     master = 1;

    `uvm_object_utils_begin(apb_agent_cfg)
        `uvm_field_int(is_active, UVM_ALL_ON | UVM_NOPACK);
        `uvm_field_int(master   , UVM_ALL_ON | UVM_NOPACK);
    `uvm_object_utils_end

    virtual apb_if vif;

    function new(string name="apb_agent_cfg");
        super.new(name);
    endfunction : new

    function void set_default();
        is_active = 1;
        master = 1;
    endfunction : set_default

endclass : apb_agent_cfg

`endif // APB_AGENT_CFG__SV
