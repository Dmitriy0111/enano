`ifndef APB_MONITOR__SV
`define APB_MONITOR__SV

//  Class: apb_monitor
//
class apb_monitor#(type apb_vif = virtual apb_if) extends uvm_monitor;
    `uvm_component_utils( apb_monitor#(apb_vif) )

    uvm_analysis_port   #(apb_item)     mon_ap;
    apb_vif                             vif;

    extern function new(string name = "apb_monitor", uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);

endclass : apb_monitor

function apb_monitor::new(string name = "apb_monitor", uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void apb_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_ap = new("mon_ap", this);
    if( ! uvm_config_db#(apb_vif)::get(this, "", "apb_vif", vif) )
        `uvm_fatal("APB|MON|NO_VIF", "No virtual interface specified for this monitor instance")
endfunction : build_phase

task apb_monitor::run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever 
    begin
        apb_item tr;
        // Wait for a SETUP cycle
        do 
        begin
            @(vif.pck);
        end
        while (vif.psel !== 1'b1 || vif.penable !== 1'b0);
        tr = apb_item#()::type_id::create("tr", this);
        tr.apb_rw_ = (vif.pwrite) ? apb_item#()::apb_write : apb_item#()::apb_read;
        tr.addr = vif.paddr;
        @(vif.pck);
        if (vif.penable !== 1'b1)
            `uvm_error("APB", "APB protocol violation: SETUP cycle not followed by ENABLE cycle");
        tr.data = (tr.apb_rw_ == apb_item#()::apb_read) ? vif.prdata : vif.pwdata;
        mon_ap.write(tr);
        `uvm_info
                    (
                        "APB|MON", 
                        { "Collect item: \n" , tr.convert2string() },
                        UVM_LOW
                    )
    end
endtask : run_phase

`endif // APB_MONITOR__SV
