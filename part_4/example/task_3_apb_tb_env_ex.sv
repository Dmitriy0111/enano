`ifndef TB_ENV__SV
`define TB_ENV__SV

class tb_env extends uvm_env;

    typedef virtual apb_if apb_vif; 

    apb_agent apb;
    apb_vif vif;

    `uvm_component_utils(tb_env)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(apb_vif)::get(this, "", "apb_vif", vif)) 
        begin
            `uvm_fatal("TB/ENV/NOVIF", "No virtual interface specified for environment instance")
        end
        apb = apb_agent::type_id::create("apb", this);
        uvm_config_db#(apb_vif)::set(this, "apb", "apb_vif", vif);
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
    endfunction : connect_phase

    task pre_reset_phase(uvm_phase phase);
        phase.raise_objection(this, "Waiting for reset to be valid");
        wait (vif.rst !== 1'bx);
        phase.drop_objection(this, "Reset is no longer X");
    endtask : pre_reset_phase

    task reset_phase(uvm_phase phase);
        phase.raise_objection(this, "Asserting reset for 10 clock cycles");
        `uvm_info("TB/TRACE", "Resetting DUT...", UVM_NONE);
        vif.rst = 1'b1;
        repeat (10) @(posedge vif.pclk);
        vif.rst = 1'b0;
        phase.drop_objection(this, "HW reset done");
    endtask : reset_phase

    task pre_configure_phase(uvm_phase phase);
        phase.raise_objection(this, "Letting the interfaces go idle");
        `uvm_info("TB/TRACE", "Configuring DUT...", UVM_NONE);
        repeat (10) @(posedge vif.pclk);
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
        repeat (16) @(posedge vif.pclk);
        phase.drop_objection(this, "DUT is empty");
    endtask : shutdown_phase

    function void report_phase(uvm_phase phase);
        uvm_report_server svr;
        svr = uvm_report_server::get_server();
        if (svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) == 0)
            $write("** UVM TEST PASSED **\n");
        else
            $write("!! UVM TEST FAILED !!\n");
    endfunction : report_phase

endclass : tb_env

`endif // TB_ENV__SV