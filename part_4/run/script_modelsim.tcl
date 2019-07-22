if [file exists "work"] {vdel -all}
vlib work

set test "task_1_apb"
set test "task_2_apb"

# compile testbench files
vlog -f ../run/tb.f

if {$test=="task_1_apb"} {    
    vsim -novopt work.task_1_apb
} elseif {$test=="task_2_apb"} {
    vsim -novopt work.task_2_apb    
}

# run simulation
run -all

coverage report -detail -cvg -directive -comments -file ../fcover_report.txt -r /

quit 