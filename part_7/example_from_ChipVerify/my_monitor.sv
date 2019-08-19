class my_monitor extends uvm_monitor;
    `uvm_component_utils( my_monitor )

    uvm_analysis_port   #(bus_pkt)  mon_ap;
    virtual     bus_if              vif;
    
    function new(string name="my_monitor", uvm_component parent);
        super.new(name, parent);
    endfunction : new
  
    virtual function void build_phase(uvm_phase phase);
        super.build_phase (phase);
        mon_ap = new("mon_ap", this);
        if(! uvm_config_db#(virtual bus_if)::get (this, "", "bus_vif", vif))
            `uvm_error(this.get_name(), "Did not get bus if handle")
    endfunction : build_phase
  
    virtual task run_phase(uvm_phase phase);
        fork
            forever begin
                @(posedge vif.pclk);
                if(vif.psel && vif.penable && vif.presetn) begin
                    bus_pkt pkt = bus_pkt::type_id::create("pkt");
                    pkt.addr = vif.paddr;
                    if (vif.pwrite)
                        pkt.data = vif.pwdata;
                    else
                        pkt.data = vif.prdata;
                    pkt.write = vif.pwrite;
                    mon_ap.write(pkt);
                end 
            end
        join_none
    endtask : run_phase

endclass : my_monitor
