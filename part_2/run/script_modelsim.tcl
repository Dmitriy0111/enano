if [file exists "work"] {vdel -all}
vlib work

#set test "task_1"
#set test "task_2"
#set test "task_3"
set test "task_4"
#set test "task_5"
#set test "task_6"

# compile testbench files
vlog -f ../run/tb.f

if {$test=="task_1"} {    
    vsim -novopt work.task_1
    add wave -position insertpoint sim:/task_1/*
} elseif {$test=="task_2"} {
    vsim -novopt work.task_2
} elseif {$test=="task_3"} {
    vsim -novopt work.task_3
} elseif {$test=="task_4"} {
    vsim -novopt work.task_4
} elseif {$test=="task_5"} {
    vsim -novopt work.task_5
} elseif {$test=="task_6"} {
    vsim -novopt work.task_6
    add wave -position insertpoint sim:/task_6/s_if_0/*
    add wave -position insertpoint sim:/task_6/s_if_1/*
    add wave -position insertpoint sim:/task_6/s_if_2/*
}

# run simulation
run -all

quit 