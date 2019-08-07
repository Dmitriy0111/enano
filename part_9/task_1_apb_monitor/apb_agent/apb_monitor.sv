`ifndef APB_MONITOR__SV
`define APB_MONITOR__SV

//  Class: apb_monitor
//
class apb_monitor#(type apb_vif = virtual apb_if) extends uvm_monitor;
    `uvm_component_utils( apb_monitor#(apb_vif) );

    uvm_analysis_port   #( apb_item )   apb_mon_ap;
    apb_vif                             vif;

    extern function      new(string name = "apb_monitor", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task          run_phase(uvm_phase phase);
   
endclass : apb_monitor

function apb_monitor::new(string name = "apb_monitor", uvm_component parent = null);
    super.new(name, parent);
endfunction: new

function void apb_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    this.apb_mon_ap = new("apb_mon_ap",this);
endfunction : build_phase

function void apb_monitor::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if( !uvm_config_db#(apb_vif)::get(this, "", "apb_vif", vif) )
        `uvm_fatal("APB|MON|NO_VIF", "No virtual interface specified")
endfunction : connect_phase

task apb_monitor::run_phase(uvm_phase phase);

endtask : run_phase

`endif // APB_MONITOR__SV
