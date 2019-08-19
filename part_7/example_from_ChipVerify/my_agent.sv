class my_agent extends uvm_agent;
    `uvm_component_utils( my_agent )

    my_driver                   m_drvr;
    my_monitor                  m_mon;
    uvm_sequencer   #(bus_pkt)  m_seqr; 
    
    function new(string name="my_agent", uvm_component parent);
       super.new(name, parent);
    endfunction : new
  
    virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        m_drvr = my_driver::type_id::create("m_drvr", this);
        m_seqr = uvm_sequencer#(bus_pkt)::type_id::create("m_seqr", this);
        m_mon = my_monitor::type_id::create("m_mon", this);
    endfunction : build_phase
  
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        m_drvr.seq_item_port.connect(m_seqr.seq_item_export);
    endfunction : connect_phase

endclass : my_agent
