class my_driver extends uvm_driver #(bus_pkt);
    `uvm_component_utils(my_driver)
  
    virtual bus_if      vif;
    bus_pkt             pkt;
  
    function new(string name = "my_driver", uvm_component parent);
        super.new(name, parent);
    endfunction : new
  
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(! uvm_config_db#(virtual bus_if)::get (this, "", "bus_vif", vif))
            `uvm_error(this.get_name(), "Did not get bus if handle")
    endfunction : build_phase
  
    virtual task run_phase (uvm_phase phase);
        bit [31:0] data;
  
        vif.psel <= 0;
        vif.penable <= 0;
        vif.pwrite <= 0;
        vif.paddr <= 0;
        vif.pwdata <= 0;
        forever begin
            seq_item_port.get_next_item (pkt);
            if (pkt.write)
                write (pkt.addr, pkt.data);
            else 
            begin
                read (pkt.addr, data);
                pkt.data = data;
            end
            seq_item_port.item_done ();
        end
    endtask : run_phase
  
    virtual task read(input bit [31:0] addr, output logic [31:0] data);
        vif.paddr <= addr;
        vif.pwrite <= 0;
        vif.psel <= 1;
        @(posedge vif.pclk);
        vif.penable <= 1;
        @(posedge vif.pclk);
        data = vif.prdata;
        vif.psel <= 0;
        vif.penable <= 0;
    endtask : read
  
    virtual task write(input bit [31:0] addr, input bit [31:0] data);
        vif.paddr <= addr;
        vif.pwdata <= data;
        vif.pwrite <= 1;
        vif.psel <= 1;
        @(posedge vif.pclk);
        vif.penable <= 1;
        @(posedge vif.pclk);
        vif.psel <= 0;
        vif.penable <= 0;
    endtask : write

endclass : my_driver
