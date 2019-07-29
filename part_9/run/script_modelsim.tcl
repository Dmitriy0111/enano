if [file exists "work"] {vdel -all}
vlib work

set test "task_1_ahb_monitor"
set test "task_1_apb_monitor"
set test "task_1_axi_monitor"

if {$test=="task_1_ahb_monitor"} {
    vlog -f ../run/ahb_monitor.f
    #vsim -novopt work.uart_tb +UVM_TESTNAME=uart_run_item_test
} elseif {$test=="task_1_apb_monitor"} {
    vlog -f ../run/apb_monitor.f
    #vsim -novopt work.apb_tb +UVM_TESTNAME=apb_run_item_test
} elseif {$test=="task_1_axi_monitor"} {
    vlog -f ../run/axi_monitor.f
    vsim -novopt work.axi_tb +UVM_TESTNAME=axi_run_test
    add wave -position insertpoint sim:/axi_tb/axi_if_/*
}

# run simulation
run -all

quit 
