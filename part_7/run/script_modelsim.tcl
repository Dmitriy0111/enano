if [file exists "work"] {vdel -all}
vlib work

set test "task_1_1"
set test "task_1_2"

if {$test=="task_1_1"} {    
    # compile testbench files
    vlog -f ../run/tb.f
    #vsim -novopt work.task_1_apb
} elseif {$test=="task_1_2"} {
    # compile testbench files
    vlog -f ../run/tb.f
    #vsim -novopt work.task_2_apb    
}

# run simulation
run -all

quit 