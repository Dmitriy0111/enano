class base_test extends uvm_test;
    `uvm_component_utils (base_test)
  
    my_env          m_env;
    uvm_status_e    status;
  
    function new(string name = "base_test", uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_env = my_env::type_id::create("m_env", this);
    endfunction : build_phase

    virtual task reset_phase(uvm_phase phase);
        super.reset_phase(phase);
        phase.raise_objection(this);
        phase.drop_objection(this);
    endtask : reset_phase

endclass : base_test
