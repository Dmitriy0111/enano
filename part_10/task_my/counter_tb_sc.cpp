#include "systemc.h"

#include "verilated.h"

#include "../obj_dir/Vcounter.h"

int sc_main(int argc, char* argv[]) {

    if( 0 && argv && argc ) {}

    Verilated::debug(0);

    Verilated::randReset(2);

    Verilated::commandArgs(argc, argv);
    
    ios::sync_with_stdio();

    sc_time sc_time_(1.0, SC_NS);
    //sc_set_default_time_unit(1,SC_NS);

    sc_clock clk("clk", 10, SC_NS, 0.5, 3, SC_NS, true);
    // defining signals
    sc_signal<bool>         resetn;
    sc_signal<bool>         dir;
    sc_signal<uint32_t>     c_out;
    // creating verilated module for counter design
    Vcounter* sc_counter = new Vcounter("counter_sc");
    // connecting verilated model to testbench signals
    sc_counter->clk    ( clk       );
    sc_counter->resetn ( resetn    );
    sc_counter->dir    ( dir       );
    sc_counter->c_out  ( c_out     );

    resetn = 0;
    dir = 0;

    for(int i=0;i<7;i++)
    {
        sc_start(10, SC_NS);
    }

    resetn = 1;

    for(int i = 0 ; i < 400 ; i++) {
        dir = 0;
        sc_start(10, SC_NS);
        cout << sc_time_stamp() << ", dir = " << ( dir ? "+" : "-" ) << ", c_out = 0x" << hex << c_out << endl;
    }

    for(int i = 0 ; i < 400 ; i++) {
        dir = 1;
        sc_start(10, SC_NS);
        cout << sc_time_stamp() << ", dir = " << ( dir ? "+" : "-" ) << ", c_out = 0x" << hex << c_out << endl;
    }

    sc_counter->final();

    delete sc_counter;
    sc_counter = NULL;

    return 0;
}
