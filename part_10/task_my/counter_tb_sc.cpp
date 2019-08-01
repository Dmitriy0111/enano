#include <systemc.h>

#include <verilated.h>

#include "../verilator_wf/counter_sc.h"

int sc_main(int argc, char* argv[]) {

    if( 0 && argv && argc ) {}

    Verilated::debug(0);

    Verilated::randReset(2);

    Verilated::commandArgs(argc, argv);
    
    ios::sync_with_stdio();

    sc_time sc_time_(1.0, sc_ns);
    sc_set_default_time_unit(sc_time_);

    sc_clock clk("clk", 10, sc_ns, 0.5, 3, sc_ns, true);
    // defining signals
    sc_signal<sc_bv<1>>     resetn;
    sc_signal<sc_bv<1>>     dir;
    sc_signal<sc_bv<8>>     c_out;
    // creating verilated module for counter design
    counter_sc* counter_sc_ = new counter_sc("counter_sc");
    // connecting verilated model to testbench signals
    counter_sc_->clk    ( clk       );
    counter_sc_->resetn ( resetn    );
    counter_sc_->dir    ( dir       );
    counter_sc_->c_out  ( c_out     );

    sc_start(1, sc_ns);

    while (!Verilated::gotFinish()) {
        resetn = 0;
        dir = 0;
        sc_start(1, sc_ns);
        cout << sc_time_stamp() << "ns, dir = " << dir ? "+" : "-" << ", c_out = 0x" << hex << c_out << endl;
    }

    for(integer i = 0 ; i < 400 ; i++) {
        dir = 0;
        sc_start(1, sc_ns);
        cout << sc_time_stamp() << "ns, dir = " << dir ? "+" : "-" << ", c_out = 0x" << hex << c_out << endl;
    }

    for(integer i = 0 ; i < 400 ; i++) {
        dir = 1;
        sc_start(1, sc_ns);
        cout << sc_time_stamp() << "ns, dir = " << dir ? "+" : "-" << ", c_out = 0x" << hex << c_out << endl;
    }

    counter_sc_->final();

    delete counter_sc_;
    counter_sc_ = NULL;

    return 0;
}
