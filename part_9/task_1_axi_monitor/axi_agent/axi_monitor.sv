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

    integer         wdata_size = 0;

    extern function new(string name = "axi_monitor", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task pars_waddr_ch();
    extern task pars_wdata_ch();
    extern task pars_raddr_ch();
   
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
    repeat(30)
    fork
        pars_waddr_ch();
        pars_wdata_ch();
        pars_raddr_ch();
    join_any
endtask : run_phase

task axi_monitor::pars_waddr_ch();
    @(posedge vif.ACLK);
    #0;
    if( vif.AWVALID )
    begin
        $display("| Address write channel cycle = %h", cycle_aw);
        $display("| AWADDR  | %h", vif.AWADDR  );
        $display("| AWLEN   | %h", vif.AWLEN   );
        $display("| AWSIZE  | %h", vif.AWSIZE  );
        $display("| AWBURST | %h\n", vif.AWBURST );
        cycle_aw++;
        wdata_size = vif.AWSIZE;
    end
endtask : pars_waddr_ch

task axi_monitor::pars_raddr_ch();
    @(posedge vif.ACLK);
    #0;
    if( vif.ARVALID )
    begin
        $display("| Address read channel cycle = %h", cycle_ar);
        $display("| ARADDR  | %h",   vif.ARADDR  );
        $display("| ARLEN   | %h",   vif.ARLEN   );
        $display("| ARSIZE  | %h",   vif.ARSIZE  );
        $display("| ARBURST | %h\n", vif.ARBURST );
        cycle_ar++;
        //wdata_size = vif.AWSIZE;
    end
endtask : pars_raddr_ch

task axi_monitor::pars_wdata_ch();
    @(posedge vif.ACLK);
    #0;
    if(vif.WVALID)
    begin
        $display("| Data write channel cycle = %h", cycle_wd);
        $display("| WDATA  |");
        for(integer i = 1; i<=2**wdata_size; i++)
        begin
            $write(" %h ", vif.WDATA[(2**wdata_size-i)*8 +: 8]);
            if( i % 16 == 0)
                $write("\n");
        end
        $write("\n");
        cycle_wd++;
    end
endtask : pars_wdata_ch

`endif // AXI_MONITOR__SV
