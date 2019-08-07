`ifndef AHB_MONITOR__SV
`define AHB_MONITOR__SV

//  Class: ahb_monitor
//
class ahb_monitor#(type ahb_vif = virtual ahb_if) extends uvm_monitor;
    `uvm_component_utils( ahb_monitor#(ahb_vif) );

    uvm_analysis_port   #( ahb_item )   ahb_mon_ap;
    ahb_vif                             vif;

    extern function      new(string name = "ahb_monitor", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task          run_phase(uvm_phase phase);
   
endclass : ahb_monitor

function ahb_monitor::new(string name = "ahb_monitor", uvm_component parent = null);
    super.new(name, parent);
endfunction: new

function void ahb_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    this.ahb_mon_ap = new("ahb_mon_ap",this);
endfunction : build_phase

function void ahb_monitor::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if( !uvm_config_db#(ahb_vif)::get(this, "", "ahb_vif", vif) )
        `uvm_fatal("AHB|MON|NO_VIF", "No virtual interface specified")
endfunction : connect_phase

task ahb_monitor::run_phase(uvm_phase phase);

endtask : run_phase

`endif // AHB_MONITOR__SV
