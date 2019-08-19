class reg_env extends uvm_env;
    `uvm_component_utils(reg_env)

    ral_sys_traffic                 m_ral_model;
    reg2apb_adapter                 m_reg2apb;
    uvm_reg_predictor   #(bus_pkt)  m_apb2reg_predictor;
    my_agent                        m_agent;

    function new(string name="reg_env", uvm_component parent);
        super.new(name, parent);
    endfunction : new
  
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_ral_model          = ral_sys_traffic::type_id::create("m_ral_model", this);
        m_reg2apb            = reg2apb_adapter::type_id::create("m_reg2apb");
        m_apb2reg_predictor  = uvm_reg_predictor#(bus_pkt)::type_id::create("m_apb2reg_predictor", this);
  
        m_ral_model.build();
        m_ral_model.lock_model();
        uvm_config_db #(ral_sys_traffic)::set(null, "uvm_test_top", "m_ral_model", m_ral_model);
    endfunction : build_phase
  
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        m_apb2reg_predictor.map       = m_ral_model.default_map;
        m_apb2reg_predictor.adapter   = m_reg2apb;
    endfunction : connect_phase

endclass : reg_env
