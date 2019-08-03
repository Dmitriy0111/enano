if [file exists "work"] {vdel -all}
vlib work

set test "task_1"
set test "task_2"
set test "task_3"
set test "task_4"
set test "task_5"
#set test "task_6"
#set test "task_7"

if {$test=="task_1"} {    
    # compile testbench files
    vlog -f ../run/tb.f
    vsim -novopt work.task_1
} elseif {$test=="task_2"} {
    # compile testbench files
    vlog -f ../run/tb.f
    vsim -novopt work.task_2
} elseif {$test=="task_3"} {
    # compile testbench files
    vlog -f ../run/tb.f
    vsim -novopt work.task_3
} elseif {$test=="task_4"} {
    # compile testbench files
    vlog -f ../run/tb.f
    vsim -novopt work.task_4
} elseif {$test=="task_5"} {
    # compile testbench files
    vlog -f ../run/tb.f
    vsim -novopt work.task_5
} elseif {$test=="task_6"} {
    # compile testbench files
    vlog -f ../run/tb.f
    vsim -novopt work.task_6
} elseif {$test=="task_7"} {
    # compile testbench files
    vlog -f ../run/tb.f
    vsim -novopt work.task_7 +seq_1
} 

# run simulation
run -all

quit 