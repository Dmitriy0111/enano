`ifndef APB_DRIVER__SV
`define APB_DRIVER__SV

//  Class: apb_driver
//
class apb_driver#(type apb_vif = virtual apb_if) extends uvm_driver#(apb_item);
    `uvm_component_utils( apb_driver#(apb_vif) )

    apb_vif     vif;

    extern function new(string name = "apb_driver", uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    extern virtual protected task read(input bit [31:0] addr, output logic [31:0] data);
    extern virtual protected task write(input bit [31:0] addr, input bit [31:0] data);
    
endclass : apb_driver

function apb_driver::new(string name = "apb_driver", uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void apb_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if( ! uvm_config_db#(apb_vif)::get(this, "", "apb_vif", vif) )
        `uvm_fatal("APB|DRV|NO_VIF","No virtual interface specified for this driver instance")
endfunction : build_phase

task apb_driver::run_phase(uvm_phase phase);
    super.run_phase(phase);
    vif.psel <= '0;
    vif.penable <= '0;
    forever 
    begin
        apb_item tr;
        @(vif.mck);
        seq_item_port.get_next_item(tr);
        // TODO: QUESTA issue with hier ref to sequence via modport; need workaround?
        //if (!vif.at_posedge.triggered)
        @(vif.mck);
        case (tr.apb_rw_)
            apb_item#()::apb_read  : read(tr.addr, tr.data);
            apb_item#()::apb_write : write(tr.addr, tr.data);
        endcase
        seq_item_port.item_done();
    end
endtask : run_phase

task apb_driver::read(input bit [31:0] addr, output logic [31:0] data);
    vif.paddr <= addr;
    vif.pwrite <= '0;
    vif.psel <= '1;
    @(vif.mck);
    vif.penable <= '1;
    @(vif.mck);
    data = vif.prdata;
    vif.psel <= '0;
    vif.penable <= '0;
endtask: read

task apb_driver::write(input bit [31:0] addr, input bit [31:0] data);
    vif.paddr <= addr;
    vif.pwdata <= data;
    vif.pwrite <= '1;
    vif.psel <= '1;
    @(vif.mck);
    vif.penable <= '1;
    @(vif.mck);
    vif.psel <= '0;
    vif.penable <= '0;
endtask: write

`endif // APB_DRIVER__SV
