if [file exists "work"] {vdel -all}
vlib work

set test "task_1"
#set test "task_2"

if {$test=="task_1"} {    
    # compile testbench files
    vlog -f ../run/tb.f
    vsim -novopt work.task_1
} elseif {$test=="task_2"} {
    # compile testbench files
    vlog -f ../run/tb.f
    vsim -novopt work.task_2    
} 

# run simulation
run -all

quit 