`ifndef UART_AGENT__SV
`define UART_AGENT__SV

class uart_agent #(type uart_vif = virtual uart_if) extends uvm_agent;

    uvm_analysis_port   #( uart_item )  agt_analysis_port;

    uart_sequencer  uart_sqr;
    uart_driver     uart_drv;
    uart_monitor    uart_mon;
    uart_agent_cfg  uart_agt_cfg;
    uart_vif        uart_vif_;
    uart_coverage   uart_cov;

    `uvm_component_utils_begin( uart_agent #( uart_vif ) )
        `uvm_field_object( uart_sqr     , UVM_ALL_ON )
        `uvm_field_object( uart_drv     , UVM_ALL_ON )
        `uvm_field_object( uart_mon     , UVM_ALL_ON )
        `uvm_field_object( uart_cov     , UVM_ALL_ON )
        `uvm_field_object( uart_agt_cfg , UVM_ALL_ON )
    `uvm_component_utils_end

    extern function new(string name, uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);

endclass : uart_agent

function uart_agent::new(string name, uvm_component parent = null);
    super.new(name, parent);
    agt_analysis_port = new( "agt_analysis_port" , this );
endfunction : new

function void uart_agent::build_phase(uvm_phase phase);
    if (!uvm_config_db#(uart_agent_cfg)::get(this,"","uart_cfg", uart_agt_cfg)) 
    begin
        `uvm_info ("UART/AGT/NOCFG","object configuration not set, it will use local configuration",UVM_HIGH)
    end
    if (uart_agt_cfg == null) 
    begin
        uart_agt_cfg = new("uart_agt_cfg");
        uart_agt_cfg.set_default();
    end
    if (uart_agt_cfg.is_active) 
    begin
        if (uart_agt_cfg.master) 
        begin
            uart_sqr = uart_sequencer::type_id::create("uart_sqr", this);
            uart_drv = uart_driver#()::type_id::create("uart_drv", this);
            uvm_config_db#(uart_agent_cfg)::set(this, "uart_drv", "uart_cfg", uart_agt_cfg);
            uvm_config_db#(uart_agent_cfg)::set(this, "uart_sqr", "uart_cfg", uart_agt_cfg);
        end 
        else 
        begin
            // create slave uart_agent
            uart_sqr = uart_sequencer::type_id::create("uart_sqr", this);
            uvm_config_db#(uart_agent_cfg)::set(this, "uart_sqr", "uart_cfg", uart_agt_cfg);
        end
    end
    uart_mon = uart_monitor#()::type_id::create("uart_mon", this);
    uart_cov = uart_coverage::type_id::create("uart_cov", this);
    uvm_config_db#(uart_agent_cfg)::set(this, "uart_mon", "uart_cfg", uart_agt_cfg);
    if (!uvm_config_db#(uart_vif)::get(this, "", "uart_vif", uart_vif_)) 
    begin
        `uvm_fatal("UART/AGT/NO_VIF", "No virtual interface specified for this agent instance")
    end
endfunction : build_phase

function void uart_agent::connect_phase(uvm_phase phase);
    if (uart_agt_cfg.is_active) 
    begin
        if (uart_agt_cfg.master) 
        begin
            uart_drv.seq_item_port.connect(uart_sqr.seq_item_export);
        end
    end
    uart_mon.mon_analysis_port.connect(agt_analysis_port);
    uart_mon.mon_analysis_port.connect(uart_cov.analysis_export);
endfunction : connect_phase

function void uart_agent::report_phase(uvm_phase phase);
    ;
endfunction : report_phase

`endif // UART_AGENT__SV
