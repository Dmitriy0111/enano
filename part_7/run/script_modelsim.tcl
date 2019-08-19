if [file exists "work"] {vdel -all}
vlib work

set test "task_1_1"
#set test "task_1_2"
set test "example"

if {$test=="task_1_1"} {    
    # compile testbench files
    vlog -f ../run/tb.f
    vsim -novopt work.task_1_1
} elseif {$test=="task_1_2"} {
    # compile testbench files
    vlog -f ../run/tb.f
    vsim -novopt work.task_1_2
} elseif {$test=="example"} {
    # compile testbench files
    vlog -f ../run/example_tb.f
    vsim -novopt work.traffic_tb
    add wave -position insertpoint sim:/traffic_tb/bus_if_0/*
}

# run simulation
run -all

quit 