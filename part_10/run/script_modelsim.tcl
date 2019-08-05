if [file exists "work"] {vdel -all}
vlib work

set test "task_1"
set test "simple_counter"
set test "param_counter"
set test "uart_transmitter_simple_tb"

if {$test=="task_1"} {    
    set i0 +incdir+../task_1
    set s0 ../task_1/*.*v
    vlog -sv -dpiheader ../task_1/task_1.h $i0 $s0 ../task_1/task_1.c
    vsim -novopt work.task_1
} elseif {$test=="simple_counter"} {
    vlog ../task_my/simple_counter/counter.v ../task_my/simple_counter/counter_tb.v
    vsim -novopt work.counter_tb
} elseif {$test=="param_counter"} {
    vlog ../task_my/param_counter/counter.v ../task_my/param_counter/counter_tb.v 
    vsim -novopt work.counter_tb -grepeat_n=400 -gcw=8
} elseif {$test=="uart_transmitter_simple_tb"} {
    vlog ../task_my/uart_transmitter/uart_transmitter.v ../task_my/uart_transmitter/uart_transmitter_tb.sv
    vsim -novopt work.uart_transmitter_tb
}


# run simulation
run -all

quit 