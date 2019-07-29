`ifndef AXI_MONITOR__SV
`define AXI_MONITOR__SV

//  Class: axi_monitor
//
class axi_monitor#(type axi_vif = virtual axi_if) extends uvm_monitor;
    `uvm_component_utils( axi_monitor#(axi_vif) );

    uvm_analysis_port   #( axi_item )   axi_mon_ap;
    axi_vif                             vif;

    integer         cycle_aw=0;
    integer         cycle_wd=0;
    integer         cycle_wr=0;
    integer         cycle_ar=0;
    integer         cycle_rd=0;

    extern function new(string name = "axi_monitor", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task pars_waddr_ch();
    extern task pars_wdata_ch();
   
endclass : axi_monitor

function axi_monitor::new(string name = "axi_monitor", uvm_component parent = null);
    super.new(name, parent);
endfunction: new

function void axi_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    this.axi_mon_ap = new("axi_mon_ap",this);
endfunction : build_phase

function void axi_monitor::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if( !uvm_config_db#(axi_vif)::get(this, "", "axi_vif", vif) )
        `uvm_fatal("AXI|MON|NO_VIF", "No virtual interface specified")
endfunction : connect_phase

task axi_monitor::run_phase(uvm_phase phase);
    forever
    fork
        begin
            @(posedge vif.ACLK);
            if( vif.AWVALID )
            begin
                $display("| Address write channel cycle = %h", cycle_aw);
                $display("| AWADDR  | %h", vif.AWADDR  );
                $display("| AWLEN   | %h", vif.AWLEN   );
                $display("| AWSIZE  | %h", vif.AWSIZE  );
                $display("| AWBURST | %h\n", vif.AWBURST );
                cycle_aw++;
            end
        end
        begin
            @(posedge vif.ACLK);
            if(vif.WVALID)
            begin
                $display("| Data write channel cycle = %h", cycle_wd);
                $display("| WDATA   | %h", vif.WDATA[96 +: 32]);
                $display("| WDATA   | %h", vif.WDATA[64 +: 32]);
                $display("| WDATA   | %h", vif.WDATA[32 +: 32]);
                $display("| WDATA   | %h", vif.WDATA[0  +: 32]);
                cycle_wd++;
            end
        end
    join
endtask : run_phase

task axi_monitor::pars_waddr_ch();
    
endtask : pars_waddr_ch

task axi_monitor::pars_wdata_ch();
   
endtask : pars_wdata_ch

`endif // AXI_MONITOR__SV
