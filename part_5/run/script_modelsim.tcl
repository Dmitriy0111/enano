if [file exists "work"] {vdel -all}
vlib work

set test "uart_tb"
set test "apb_tb"

if {$test=="uart_tb"} {
    vlog -f ../run/uart_tb.f
    vsim -novopt work.uart_tb +UVM_TESTNAME=uart_run_item_test
} elseif {$test=="apb_tb"} {
    vlog -f ../run/apb_tb.f
    vsim -novopt work.apb_tb +UVM_TESTNAME=apb_run_item_test
}

# run simulation
run -all

quit 
