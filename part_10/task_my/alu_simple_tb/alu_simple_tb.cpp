#include "systemc.h"

#include "verilated.h"

#include "../obj_dir/Valu.h"

#define ADD_op  1
#define SUB_op  2
#define SRL_op  4
#define SLL_op  8
#define OR_op   16
#define AND_op  32
#define XOR_op  64

int sc_main(int argc, char** argv){

    Verilated::debug(0);

    Verilated::randReset(2);

    Verilated::commandArgs(argc, argv);

    ios::sync_with_stdio();
    cout << "Creating trace file." << endl;
    sc_trace_file* sc_tf;
    sc_tf = sc_create_vcd_trace_file("alu_simpe_tb");
    sc_tf->set_time_unit(1.0, SC_NS);
    cout << "Trace file created." << endl;

    sc_time sc_time_(1.0, SC_NS);

    sc_signal<uint32_t>     opcode;
    sc_signal<uint32_t>     op_0;
    sc_signal<uint32_t>     op_1;
    sc_signal<bool>         zero_f;
    sc_signal<uint32_t>     result;

    sc_trace( sc_tf , opcode , "opcode" );
    sc_trace( sc_tf , op_0   , "op_0  " );
    sc_trace( sc_tf , op_1   , "op_1  " );
    sc_trace( sc_tf , zero_f , "zero_f" );
    sc_trace( sc_tf , result , "result" );

    cout << "Creating dut instance." << endl;
    // creating verilated module for counter design
    Valu* sc_dut = new Valu("Valu");
    // connecting verilated model to testbench signals
    sc_dut->opcode  ( opcode    );
    sc_dut->op_0    ( op_0      );
    sc_dut->op_1    ( op_1      );
    sc_dut->zero_f  ( zero_f    );
    sc_dut->result  ( result    );
    cout << "Dut instance created." << endl;
    cout << "Simulation start." << endl;

    uint32_t exp_result;

    for( int i = 0 ; i < 200 ; i++ ) {
    
        opcode = 1 << rand() % 6;
        cout << "Random opcode = " <<   ( ( opcode == ADD_op ) ? "ADD_op" : 
                                          ( opcode == SUB_op ) ? "SUB_op" : 
                                          ( opcode == SRL_op ) ? "SRL_op" :
                                          ( opcode == SLL_op ) ? "SLL_op" :
                                          ( opcode == OR_op  ) ? "OR_op " :
                                          ( opcode == AND_op ) ? "AND_op" :
                                          ( opcode == XOR_op ) ? "XOR_op" :
                                                                 "UNK_op" ) << ", ";
        op_0 = rand() % 255;
        cout << "op_0 = 0x" << op_0 << hex << ", ";
        op_1 = rand() % 255;
        cout << "op_1 = 0x" << op_1 << hex << ", ";
        exp_result = 0;
        switch( opcode ) {
            case ADD_op  : exp_result = op_0  + op_1; exp_result &= 255; break;
            case SUB_op  : exp_result = op_0  - op_1; exp_result &= 255; break;
            case SRL_op  : exp_result = op_0 << op_1; exp_result &= 255; break;
            case SLL_op  : exp_result = op_0 >> op_1; exp_result &= 255; break;
            case OR_op   : exp_result = op_0  | op_1; exp_result &= 255; break;
            case AND_op  : exp_result = op_0  & op_1; exp_result &= 255; break;
            case XOR_op  : exp_result = op_0  ^ op_1; exp_result &= 255; break;
            default      : exp_result = -1;                              break;
        };
        cout << "expected result = 0x" << exp_result << hex << ", ";
        cout << "alu result = 0x" << result << hex << ", ";
        cout << " Test " << ( ( exp_result == result ) ? "Pass" : "Fail" )  << endl;
        sc_start(10, SC_NS);
    }

    sc_dut->final();

    delete sc_dut;
    
    sc_close_vcd_trace_file(sc_tf);

    cout << "Simulation end." << endl;

    return 0;

}
