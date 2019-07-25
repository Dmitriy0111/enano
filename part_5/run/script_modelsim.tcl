if [file exists "work"] {vdel -all}
vlib work

vlog -f ../run/tb.f
vsim -novopt work.uart_tb +UVM_TESTNAME=uart_run_item_test

# run simulation
run -all

quit 
