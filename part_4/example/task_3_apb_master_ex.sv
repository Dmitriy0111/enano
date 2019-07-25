`ifndef APB_MASTER__SV
`define APB_MASTER__SV

class apb_master extends uvm_driver #(apb_item);

    typedef virtual apb_if apb_vif; 

    `uvm_component_utils(apb_master)

    event trig;

    apb_vif sigs;
    apb_agent_cfg cfg;

    function new(string name, uvm_component parent = null);
        super.new(name,parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(apb_vif)::get(this, "", "apb_vif", sigs)) 
        begin
            `uvm_fatal("APB/DRV/NOVIF", "No virtual interface specified for this driver instance")
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        this.sigs.mck.psel <= '0;
        this.sigs.mck.penable <= '0;
        forever 
        begin
            apb_item tr;
            @ (this.sigs.mck);
            seq_item_port.get_next_item(tr);
            // TODO: QUESTA issue with hier ref to sequence via modport; need workaround?
            //if (!this.sigs.mck.at_posedge.triggered)
            @ (this.sigs.mck);
            this.trans_received(tr);
            case (tr.kind)
                apb_item::READ:     this.read(tr.addr, tr.data);
                apb_item::WRITE:    this.write(tr.addr, tr.data);
            endcase
            this.trans_executed(tr);
            seq_item_port.item_done();
            ->trig ;
        end
    endtask : run_phase
    
    virtual protected task read(input bit [31 : 0] addr, output logic [31 : 0] data);
        this.sigs.mck.paddr <= addr;
        this.sigs.mck.pwrite <= '0;
        this.sigs.mck.psel <= '1;
        @ (this.sigs.mck);
        this.sigs.mck.penable <= '1;
        @ (this.sigs.mck);
        data = this.sigs.mck.prdata;
        this.sigs.mck.psel <= '0;
        this.sigs.mck.penable <= '0;
    endtask: read

    virtual protected task write(input bit [31 : 0] addr, input bit [31 : 0] data);
        this.sigs.mck.paddr <= addr;
        this.sigs.mck.pwdata <= data;
        this.sigs.mck.pwrite <= '1;
        this.sigs.mck.psel <= '1;
        @ (this.sigs.mck);
        this.sigs.mck.penable <= '1;
        @ (this.sigs.mck);
        this.sigs.mck.psel <= '0;
        this.sigs.mck.penable <= '0;
    endtask: write

    virtual protected task trans_received(apb_item tr);
    endtask

    virtual protected task trans_executed(apb_item tr);
    endtask

endclass: apb_master

`endif // APB_MASTER__SV
