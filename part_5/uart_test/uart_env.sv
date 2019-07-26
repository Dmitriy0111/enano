`ifndef UART_ENV__SV
`define UART_ENV__SV

class uart_env#(type uart_vif = virtual uart_if) extends uvm_env;

    uart_agent          uart_agent_;
    uart_vif            uart_vif_;
    uart_subscriber     uart_subscriber_;
    uart_agent_cfg      uart_agt_cfg;


    `uvm_component_utils( uart_env#(uart_vif) )

    extern function new(string name, uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task pre_reset_phase(uvm_phase phase);
    extern task reset_phase(uvm_phase phase);
    extern task pre_configure_phase(uvm_phase phase);
    extern task configure_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);

endclass : uart_env

function uart_env::new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void uart_env::build_phase(uvm_phase phase);
    if (!uvm_config_db#(uart_vif)::get(this, "", "uart_vif", uart_vif_))
    begin
        `uvm_fatal("TB/ENV/NOVIF", "No virtual interface specified for environment instance")
    end
    uart_agt_cfg = uart_agent_cfg::type_id::create("uart_cfg",this);
    uart_agt_cfg.set_default();

    uart_agent_ = uart_agent#()::type_id::create("uart_agent_", this);
    uvm_config_db#(uart_agent_cfg)::set(this.uart_agent_,"","uart_cfg", uart_agt_cfg);
    uart_subscriber_ = uart_subscriber::type_id::create("uart_subscriber_",this);
    uvm_config_db#(uart_vif)::set(this, "uart_agent_", "uart_vif", uart_vif_);
endfunction : build_phase

function void uart_env::connect_phase(uvm_phase phase);
    uart_agent_.agt_analysis_port.connect(uart_subscriber_.analysis_export);
endfunction : connect_phase

task uart_env::pre_reset_phase(uvm_phase phase);
    phase.raise_objection(this, "Waiting for reset to be valid");
    wait (uart_vif_.resetn !== 1'bx);
    phase.drop_objection(this, "Reset is no longer X");
endtask : pre_reset_phase

task uart_env::reset_phase(uvm_phase phase);
    phase.raise_objection(this, "Asserting reset for 10 clock cycles");
    `uvm_info("TB/TRACE", "Resetting DUT...", UVM_NONE);
    uart_vif_.resetn = 1'b0;
    repeat (10) @(posedge uart_vif_.clk);
    uart_vif_.resetn = 1'b1;
    phase.drop_objection(this, "HW reset done");
endtask : reset_phase

task uart_env::pre_configure_phase(uvm_phase phase);
    phase.raise_objection(this, "Letting the interfaces go idle");
    `uvm_info("TB/TRACE", "Configuring DUT...", UVM_NONE);
    repeat (10) @(posedge uart_vif_.clk);
    phase.drop_objection(this, "Ready to configure");
endtask : pre_configure_phase

task uart_env::configure_phase(uvm_phase phase);
    phase.raise_objection(this, "Programming DUT");
    phase.drop_objection(this, "Everything is ready to go");
endtask : configure_phase
    
function void uart_env::report_phase(uvm_phase phase);
    uvm_report_server svr;
    svr = uvm_report_server::get_server();
    if ( svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) == 0 )
        $write("** UVM TEST PASSED **\n");
    else
        $write("!! UVM TEST FAILED !!\n");
endfunction : report_phase

`endif // UART_ENV__SV
