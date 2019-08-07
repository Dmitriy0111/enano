
help:
	$(info make help           - show this message)
	$(info make clean          - delete synth and simulation folders)
	$(info make sim            - the same as sim_gui)
	$(info make sim_cmd        - run simulation in Modelsim (console mode))
	$(info make sim_gui        - run simulation in Modelsim (gui mode))
	$(info Open and read the Makefile for details)
	@true

PWD     := $(shell pwd)
RTL_DIR  = $(PWD)/rtl
TB_DIR   = $(PWD)/tb

########################################################
# common make targets

show_pwd:
	PWD

clean: \
	sim_clean \
	log_clean

sim_all: \
	sim_cmd 

sim: sim_gui

########################################################
# simulation - Modelsim

VSIM_DIR = $(PWD)/sim_modelsim

VLIB_BIN = cd $(VSIM_DIR) && vlib
VLOG_BIN = cd $(VSIM_DIR) && vlog
VSIM_BIN = cd $(VSIM_DIR) && vsim

VSIM_OPT_COMMON += -do $(PWD)/run/script_modelsim.tcl -onfinish final

VSIM_OPT_CMD     = -c
VSIM_OPT_CMD    += -onfinish exit

VSIM_OPT_GUI     = -gui -onfinish stop

sim_clean:
	rm -rfd $(VSIM_DIR)

sim_dir: sim_clean
	mkdir $(VSIM_DIR)

sim_cmd: sim_dir
	$(VSIM_BIN) $(VSIM_OPT_COMMON) $(VSIM_OPT_CMD)

sim_gui: sim_dir
	$(VSIM_BIN) $(VSIM_OPT_COMMON) $(VSIM_OPT_GUI) &

log_clean:
	rm -rfd .log

########################################################
# Compile (task_3)

compile_risc_v:
	mkdir -p program_file
	riscv-none-embed-as task_3/task_3_risc_v.S -c -o program_file/main_risc_v.o -march=rv32i -mabi=ilp32
	riscv-none-embed-ld -o program_file/main_risc_v.elf -Map program_file/main_risc_v.map program_file/main_risc_v.o -b elf32-littleriscv
	riscv-none-embed-objdump -M no-aliases -S -w --disassemble-zeroes program_file/main_risc_v.elf > program_file/main_risc_v.lst

compile_arm:
	mkdir -p program_file
	arm-none-eabi-as -o program_file/main_arm.o task_3/task_3_arm.S
	arm-none-eabi-ld -Ttext=0x0 -o program_file/main_arm.elf program_file/main_arm.o
	arm-none-eabi-objdump -S -w --disassemble-zeroes program_file/main_arm.elf > program_file/main_arm.lst

compile_clean:
	rm -rfd program_file

########################################################
# Systemc (task_2)

systemc_test:
	mkdir -p systemc_exe
	g++ -I. -I$(SYSTEMC_HOME)/include -L. -L$(SYSTEMC_HOME)/lib-linux64 -Wl,-rpath=$(SYSTEMC_HOME)/lib-linux64 -o systemc_exe/sc_tb task_2/sc_tb.cpp -lsystemc -lm

systemc_hello:
	mkdir -p systemc_exe
	g++ -I. -I$(SYSTEMC_HOME)/include -L. -L$(SYSTEMC_HOME)/lib-linux64 -Wl,-rpath=$(SYSTEMC_HOME)/lib-linux64 -o systemc_exe/sc_hello task_2/sc_hello.cpp -lsystemc -lm

systemc_clean:
	rm -rfd systemc_exe

########################################################
# Verilog 2 C

simple_counter_v2sc:
	verilator -sc task_my/simple_counter/counter.v -Wall

param_counter_v2sc:
	verilator -sc task_my/param_counter/counter.v -Wall

uart_transmitter_v2sc:
	verilator -sc task_my/uart_transmitter_simple_tb/uart_transmitter.v -Wall

verilator_clean:
	rm -rfd obj_dir

########################################################
# Verilator + SystemC

verilator_simple_counter:
	rm -rfd obj_dir
	$(info Convert counter project to SystemC)
	verilator -sc --exe task_my/simple_counter/counter.v task_my/simple_counter/counter_tb_sc.cpp
	$(info Create Vcounter executable)
	$(MAKE) -j 4 -C obj_dir -f Vcounter.mk
	$(info Run Vcounter test)
	obj_dir/Vcounter
	$(info See vcd diagrams)
	gtkwave simple_counter.vcd

verilator_param_counter:
	rm -rfd obj_dir
	$(info Convert counter project to SystemC)
	verilator -sc --exe task_my/param_counter/counter.v task_my/param_counter/counter_tb_sc.cpp
	$(info Create Vcounter executable)
	$(MAKE) -j 4 -C obj_dir -f Vcounter.mk
	$(info Run Vcounter test)
	obj_dir/Vcounter
	$(info See vcd diagrams)
	gtkwave param_counter.vcd

verilator_uart_transmitter_simple_tb:
	rm -rfd obj_dir
	verilator -sc --exe task_my/uart_transmitter_simple_tb/uart_transmitter.v task_my/uart_transmitter_simple_tb/uart_transmitter_tb_sc.cpp
	$(MAKE) -j 4 -C obj_dir -f Vuart_transmitter.mk
	obj_dir/Vuart_transmitter
	gtkwave uart_transmitter.vcd

verilator_uart_transmitter_sc_tb_system:
	rm -rfd obj_dir
	verilator -sc --exe task_my/uart_transmitter/uart_transmitter.v task_my/uart_transmitter/sc_tb_system.cpp
	$(MAKE) -j 4 -C obj_dir -f Vuart_transmitter.mk
	obj_dir/Vuart_transmitter
	gtkwave sc_tb_system.vcd
