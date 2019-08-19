package my_pkg;

    `include "uvm_macros.svh"
    import uvm_pkg::*;
    
    `include "bus_pkt.sv"
    `include "my_monitor.sv"
    `include "my_driver.sv"
    `include "my_agent.sv"

    `include "ral_cfg_stat.sv"
    `include "ral_cfg_timer.sv"
    `include "ral_cfg_ctl.sv"
    `include "ral_block_traffic_cfg.sv"
    `include "ral_sys_traffic.sv"
    `include "reg2apb_adapter.sv"

    `include "reg_env.sv"
    `include "my_env.sv"
    `include "base_test.sv"
    `include "reg_rw_test.sv"

endpackage: my_pkg
