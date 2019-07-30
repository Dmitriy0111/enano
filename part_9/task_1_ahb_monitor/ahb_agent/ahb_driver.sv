`ifndef AHB_DRIVER__SV
`define AHB_DRIVER__SV

//  Class: ahb_driver
//
class ahb_driver#(type ahb_vif = virtual ahb_if) extends uvm_driver#(ahb_item);
    `uvm_component_utils( ahb_driver#(ahb_vif) );

    ahb_vif             vif;

    extern function new(string name = "ahb_driver", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    
endclass : ahb_driver

function ahb_driver::new(string name = "ahb_driver", uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void ahb_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction : build_phase

function void ahb_driver::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if( !uvm_config_db#(ahb_vif)::get(this, "", "ahb_vif", vif) )
        `uvm_fatal("AHB|DRV|NO_VIF", "No virtual interface specified")
endfunction : connect_phase

task ahb_driver::run_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    phase.drop_objection(this);
endtask : run_phase

`endif // AHB_DRIVER__SV
