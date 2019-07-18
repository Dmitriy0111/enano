if [file exists "work"] {vdel -all}
vlib work

# compile testbench files
vlog -f ../run/tb.f

vsim -novopt work.task_3

set NoQuitOnFinish 1
onbreak {resume}
log /* -r
# run simulation
run -all

quit 