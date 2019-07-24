`ifndef UART_ENV__SV
`define UART_ENV__SV

import      uvm_pkg::*;
`include    "uvm_macros.svh"

import task_3_uart_pkg::*;

class uart_env extends uvm_env;

    typedef virtual uart_if uart_vif;

    uart_agent  uart_agent_;
    uart_vif    uart_if_;

    `uvm_component_utils(uart_env)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(uart_vif)::get(this, "", "uart_vif", uart_if_))
        begin
            `uvm_fatal("TB/ENV/NOVIF", "No virtual interface specified for environment instance")
        end
        uart_agent_ = uart_agent::type_id::create("uart_agent_", this);
        uvm_config_db#(uart_vif)::set(this, "uart_agent_", "uart_vif", uart_if_);
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
    endfunction : connect_phase

    task pre_reset_phase(uvm_phase phase);
        phase.raise_objection(this, "Waiting for reset to be valid");
        wait (uart_if_.resetn !== 1'bx);
        phase.drop_objection(this, "Reset is no longer X");
    endtask : pre_reset_phase

    task reset_phase(uvm_phase phase);
        phase.raise_objection(this, "Asserting reset for 10 clock cycles");
        `uvm_info("TB/TRACE", "Resetting DUT...", UVM_NONE);
        uart_if_.resetn = 1'b0;
        repeat (10) @(posedge uart_if_.clk);
        uart_if_.resetn = 1'b1;
        phase.drop_objection(this, "HW reset done");
    endtask : reset_phase

    task pre_configure_phase(uvm_phase phase);
        phase.raise_objection(this, "Letting the interfaces go idle");
        `uvm_info("TB/TRACE", "Configuring DUT...", UVM_NONE);
        repeat (10) @(posedge uart_if_.clk);
        phase.drop_objection(this, "Ready to configure");
    endtask : pre_configure_phase

    task configure_phase(uvm_phase phase);
        phase.raise_objection(this, "Programming DUT");
        phase.drop_objection(this, "Everything is ready to go");
    endtask : configure_phase

    task pre_main_phase(uvm_phase phase);
        phase.raise_objection(this, "Waiting for VIPs and DUT to acquire SYNC");
        `uvm_info("TB/TRACE", "Synchronizing interfaces...", UVM_NONE);
        phase.drop_objection(this, "Everyone is in SYNC");
    endtask : pre_main_phase

    task main_phase(uvm_phase phase);
        `uvm_info("TB/TRACE", "Applying primary stimulus...", UVM_NONE);
        fork
        begin
            uvm_objection obj;
            #2000000;
            obj = phase.get_objection();
            obj.display_objections();
            $finish;
        end
        begin
            uvm_objection ph_obj = phase.get_objection();
            phase.raise_objection(this, "Additional configuration ISR");
            `uvm_info("TB/TRACE", "Run phase env ...", UVM_NONE);
            #20000;
            `uvm_info("TB/TRACE", "Run phase env end...", UVM_NONE);
            phase.drop_objection(this, "Additional configuration ISR");
        end
        join
    endtask : main_phase

    task shutdown_phase(uvm_phase phase);
        phase.raise_objection(this, "Draining the DUT");
        `uvm_info("TB/TRACE", "Draining the DUT...", UVM_NONE);
        repeat (16) @(posedge uart_if_.clk);
        phase.drop_objection(this, "DUT is empty");
    endtask : shutdown_phase
        
    function void report_phase(uvm_phase phase);
        uvm_report_server svr;
        svr = uvm_report_server::get_server();
        if (
                svr.get_severity_count(UVM_FATAL) +
                svr.get_severity_count(UVM_ERROR) == 0
            )
            $write("** UVM TEST PASSED **\n");
        else
            $write("!! UVM TEST FAILED !!\n");
    endfunction : report_phase

endclass : uart_env

`endif // UART_ENV__SV
