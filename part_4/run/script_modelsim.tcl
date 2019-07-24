if [file exists "work"] {vdel -all}
vlib work

set test "task_1_apb"
set test "task_2_apb"
set test "task_1_uart"
set test "task_2_uart"
set test "task_3_uart"
#set test "task_3_apb"

if {$test=="task_1_apb"} {    
    # compile testbench files
    vlog -f ../run/tb.f
    vsim -novopt work.task_1_apb
} elseif {$test=="task_2_apb"} {
    # compile testbench files
    vlog -f ../run/tb.f
    vsim -novopt work.task_2_apb    
} elseif {$test=="task_1_uart"} {
    # compile testbench files
    vlog -f ../run/tb.f
    vsim -novopt work.task_1_uart    
} elseif {$test=="task_2_uart"} {
    # compile testbench files
    vlog -f ../run/tb.f
    vsim -novopt work.task_2_uart    
} elseif {$test=="task_3_uart"} {
    # compile testbench files
    vlog -f ../run/tb_task_3.f
    #vsim -novopt work.top +UVM_VERBOSITY=UVM_DEBUG
    vsim -novopt work.top
    add wave -position insertpoint sim:/top/uart_if_/*
} elseif {$test=="task_3_apb"} {
    # compile testbench files
    vlog -f ../run/tb_task_3_ex.f 
    #vsim -novopt work.top +UVM_VERBOSITY=UVM_DEBUG
    vsim -novopt work.top
}

# run simulation
run -all

quit 