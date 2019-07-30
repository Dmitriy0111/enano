`ifndef APB_DRIVER__SV
`define APB_DRIVER__SV

//  Class: apb_driver
//
class apb_driver#(type apb_vif = virtual apb_if) extends uvm_driver#(apb_item);
    `uvm_component_utils( apb_driver#(apb_vif) );

    apb_vif             vif;

    extern function new(string name = "apb_driver", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    
endclass : apb_driver

function apb_driver::new(string name = "apb_driver", uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void apb_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction : build_phase

function void apb_driver::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if( !uvm_config_db#(apb_vif)::get(this, "", "apb_vif", vif) )
        `uvm_fatal("APB|DRV|NO_VIF", "No virtual interface specified")
endfunction : connect_phase

task apb_driver::run_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    phase.drop_objection(this);
endtask : run_phase

`endif // APB_DRIVER__SV
