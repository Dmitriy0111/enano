if [file exists "work"] {vdel -all}
vlib work

set test "task_1"

if {$test=="task_1"} {    
    set i0 +incdir+../task_1
    set s0 ../task_1/*.*v
    vlog -sv -dpiheader ../task_1/task_1.h $i0 $s0 ../task_1/task_1.c
    vsim -novopt work.task_1
} 

# run simulation
run -all

quit 