`ifndef AXI_DRIVER__SV
`define AXI_DRIVER__SV

//  Class: axi_driver
//
class axi_driver#(type axi_vif = virtual axi_if) extends uvm_driver#(axi_item);
    `uvm_component_utils( axi_driver#(axi_vif) );

    axi_vif         vif;

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
endfunction : build_phase

function void axi_driver::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if( !uvm_config_db#(axi_vif)::get(this, "", "axi_vif", vif) )
        `uvm_fatal("AXI|DRV|NO_VIF", "No virtual interface specified")
endfunction : connect_phase

task axi_driver::run_phase(uvm_phase phase);
    phase.raise_objection(this);
    forever
    begin
        axi_item item;
        integer i;
        integer j;
        logic   [1023 : 0]  test_logic;
        seq_item_port.get_next_item(item);
        $display(item.convert2string);
        if( item.axi_rw_ == 1 )
        begin
            vif.AWID     = '0;
            vif.AWADDR   = item.addr;
            vif.AWBURST  = item.burst;
            vif.AWLEN    = item.len;
            vif.AWSIZE   = item.size;
            @(posedge vif.ACLK);
            vif.AWVALID  = '1;
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
                while(i != 2**vif.AWSIZE-1);
                vif.WDATA = test_logic;
                j = j + i;
                i='0;
                vif.WVALID = '1;
                @(posedge vif.ACLK);
            end
            vif.WVALID = '0;
        end
        else
        begin
            vif.ARID     = '0;
            vif.ARADDR   = item.addr;
            vif.ARBURST  = item.burst;
            vif.ARLEN    = item.len;
            vif.ARSIZE   = item.size;
            vif.ARVALID = '1;
            @(posedge vif.ACLK);
            vif.ARVALID = '0;
            @(posedge vif.ACLK);
        end
        seq_item_port.item_done();
    end
    phase.drop_objection(this);
endtask : run_phase

`endif // AXI_DRIVER__SV
