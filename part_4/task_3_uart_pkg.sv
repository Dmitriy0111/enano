package task_3_uart_pkg;

    import      uvm_pkg::*;
    `include    "uvm_macros.svh"

    `include "../task_3_uart_item.sv"
    `include "../task_3_uart_base_seq.sv"
    `include "../task_3_uart_rand_seq.sv"
    `include "../task_3_uart_sequencer.sv"
    `include "../task_3_uart_agent_cfg.sv"
    `include "../task_3_uart_driver.sv"
    `include "../task_3_uart_monitor.sv"
    `include "../task_3_uart_agent.sv"
    `include "../task_3_uart_env.sv"   
    `include "../task_3_uart_base_test.sv"  
    `include "../task_3_uart_run_item_test.sv"  

endpackage : task_3_uart_pkg