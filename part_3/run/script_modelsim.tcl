if [file exists "work"] {vdel -all}
vlib work

set test "task_12_1"
set test "task_12_2"
#set test "task_12_3"
#set test "task_12_4"

# compile testbench files
vlog -f ../run/tb.f

if {$test=="task_12_1"} {    
    vsim -novopt work.task_12_1
} elseif {$test=="task_12_2"} {
    vsim -novopt work.task_12_2
} elseif {$test=="task_12_3"} {
    vsim -novopt work.task_12_3
} elseif {$test=="task_12_4"} {
    vsim -novopt work.task_12_4
} 

# run simulation
run -all

quit 