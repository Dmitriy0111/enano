`ifndef APB_MONITOR__SV
`define APB_MONITOR__SV

import      uvm_pkg::*;
`include    "uvm_macros.svh"

import task_3_apb_pkg_ex::*;

class apb_monitor extends uvm_monitor;

    typedef virtual apb_if apb_vif; 

    apb_vif sigs;
    uvm_analysis_port#(apb_item) ap;
    apb_agent_cfg cfg;

    `uvm_component_utils(apb_monitor)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        ap = new("ap", this);
        if (!uvm_config_db#(apb_vif)::get(this, "", "apb_vif", sigs)) 
        begin
            `uvm_fatal("APB/MON/NOVIF", "No virtual interface specified for this monitor instance")
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever 
        begin
            apb_item tr;
            // Wait for a SETUP cycle
            do 
            begin
                @ (this.sigs.pck);
            end
            while (this.sigs.pck.psel !== 1'b1 || this.sigs.pck.penable !== 1'b0);
            tr = apb_item::type_id::create("tr", this);
            tr.kind = (this.sigs.pck.pwrite) ? apb_item::WRITE : apb_item::READ;
            tr.addr = this.sigs.pck.paddr;
            @ (this.sigs.pck);
            if (this.sigs.pck.penable !== 1'b1) 
            begin
                `uvm_error("APB", "APB protocol violation: SETUP cycle not followed by ENABLE cycle");
            end
            tr.data = (tr.kind == apb_item::READ) ? this.sigs.pck.prdata :
            this.sigs.pck.pwdata;
            ap.write(tr);
            `uvm_info ("APB/MONITOR",$sformatf("Collect item: \n%s",tr.convert2string()),UVM_LOW)
        end
    endtask : run_phase

endclass: apb_monitor

`endif // APB_MONITOR__SV
