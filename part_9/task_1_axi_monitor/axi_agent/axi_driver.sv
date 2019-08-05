`ifndef AXI_DRIVER__SV
`define AXI_DRIVER__SV

//  Class: axi_driver
//
class axi_driver#(type axi_vif = virtual axi_if) extends uvm_driver#(axi_item);
    `uvm_component_utils( axi_driver#(axi_vif) );

    axi_vif             vif;
    axi_agent_cfg       axi_drv_cfg;
    bit     [0 : 0]     is_master;

    extern function new(string name = "axi_driver", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    
    
endclass : axi_driver

function axi_driver::new(string name = "axi_driver", uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void axi_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if( !uvm_config_db#(axi_agent_cfg)::get(this, "", "axi_cfg", axi_drv_cfg) )
        `uvm_info("AXI|DRV|NO_CFG", "No driver configuration detected.", UVM_LOW)
    if( axi_drv_cfg == null )
    begin
        axi_drv_cfg = new("axi_drv_cfg");
        axi_drv_cfg.set_default();
    end
    is_master = axi_drv_cfg.is_master;
    `uvm_info("AXI|DRV|CFG", { "Driver is " , is_master ? "Master" : "Slave" } , UVM_LOW)
endfunction : build_phase

function void axi_driver::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if( !uvm_config_db#(axi_vif)::get(this, "", "axi_vif", vif) )
        `uvm_fatal("AXI|DRV|NO_VIF", "No virtual interface specified")
endfunction : connect_phase

task axi_driver::run_phase(uvm_phase phase);
    phase.raise_objection(this);
    case( is_master )
        '1  :
            begin
                vif.AWADDR   = '0;
                vif.AWBURST  = '0;
                vif.AWLEN    = '0;
                vif.AWSIZE   = '0;
                vif.AWVALID  = '0;
                vif.ARADDR   = '0;
                vif.ARBURST  = '0;
                vif.ARLEN    = '0;
                vif.ARSIZE   = '0;
                vif.ARVALID  = '0;
                vif.WDATA    = '0;
                vif.WVALID   = '0;
                vif.BVALID   = '0;
                vif.RREADY   = '0;
                vif.BREADY   = '0;
                repeat(30)
                begin
                    axi_item item;
                    integer i;
                    integer j;
                    logic   [1023 : 0]  test_logic;
                    seq_item_port.get_next_item(item);
                    $display(item.convert2string);
                    if( item.axi_rw_ == 1 )
                    begin
                        vif.AWADDR   = item.addr;
                        vif.AWBURST  = item.burst;
                        vif.AWLEN    = item.len / 2**item.size - 1;
                        vif.AWSIZE   = item.size;
                        @(posedge vif.ACLK);
                        vif.AWVALID  = '1;
                        wait( vif.AWREADY );
                        @(posedge vif.ACLK);
                        vif.AWVALID  = '0;
                        i = 0;
                        j = 0;
                        while( j<item.data.size )
                        begin
                            //vif.WDATA = item.data[i];
                            test_logic = '0;
                            do
                            begin
                                test_logic[8*i +: 8] = item.data[i + j];
                                i++;
                            end
                            while(i != 2**vif.AWSIZE);
                            vif.WDATA = test_logic;
                            j = j + i;
                            i='0;
                            vif.WVALID = '1;
                            wait(vif.WREADY);
                            @(posedge vif.ACLK);
                        end
                        vif.WVALID = '0;
                    end
                    else
                    begin
                        integer rlen;
                        vif.ARADDR   = item.addr;
                        vif.ARBURST  = item.burst;
                        vif.ARLEN    = item.len / 2**item.size - 1;
                        rlen = vif.ARLEN;
                        vif.ARSIZE   = item.size;
                        @(posedge vif.ACLK);
                        vif.ARVALID  = '1;
                        wait( vif.ARREADY );
                        @(posedge vif.ACLK);
                        vif.ARVALID  = '0;
                        @(posedge vif.ACLK);
                        vif.RREADY = '1;
                        repeat(rlen+1) @(posedge vif.ACLK);
                        vif.RREADY = '0;
                    end
                    seq_item_port.item_done();
                end
            end
        '0  :
            begin
                integer wlen;
                integer rsize;
                integer rlen;
                vif.AWREADY = '0;
                vif.ARREADY = '0;
                vif.RDATA   = '0;
                vif.BRESP   = '0;
                vif.BVALID  = '0;
                vif.RRESP   = '0;
                vif.RVALID  = '0;
                vif.WREADY  = '0;
                repeat(30)
                begin
                    @(posedge vif.ACLK);
                    #0;
                    if( vif.AWVALID )
                    begin
                        repeat($urandom_range(1,4))
                        @(posedge vif.ACLK);
                        vif.AWREADY = '1;
                        wlen = vif.AWLEN + 1;
                        @(posedge vif.ACLK);
                        vif.AWREADY = '0;
                    end
                    if( vif.ARVALID )
                    begin
                        repeat($urandom_range(1,4))
                        @(posedge vif.ACLK);
                        vif.ARREADY = '1;
                        rsize = vif.ARSIZE;
                        rlen = vif.ARLEN + 1;
                        @(posedge vif.ACLK);
                        vif.ARREADY = '0;
                    end
                    if( vif.WVALID )
                    begin
                        @(posedge vif.ACLK);
                        vif.WREADY = '1;
                        repeat(wlen) @(posedge vif.ACLK);
                        vif.WREADY = '0;
                    end
                    if( vif.RREADY )
                    begin
                        repeat(rlen+1)
                        begin
                            vif.RVALID = '1;
                            vif.RDATA = '0;
                            for(integer i=0 ; i<2**rsize ; i++)
                                vif.RDATA[i*8 +: 8] = $random();
                            @(posedge vif.ACLK);
                            vif.RVALID = '0;
                        end
                    end
                end
            end
    endcase
    phase.drop_objection(this);
endtask : run_phase

`endif // AXI_DRIVER__SV
