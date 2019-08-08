#include "systemc.h"

#include "verilated.h"

#include "../obj_dir/Vcounter.h"

int sc_main(int argc, char* argv[]) {

    if( 0 && argv && argc ) {}

    Verilated::debug(0);

    Verilated::randReset(2);

    Verilated::commandArgs(argc, argv);
    
    ios::sync_with_stdio();
    cout << "Creating trace file." << endl;
    sc_trace_file* sc_tf;
    sc_tf = sc_create_vcd_trace_file("simple_counter");
    sc_tf->set_time_unit(1.0, SC_NS);
    cout << "Trace file created." << endl;

    sc_time sc_time_(1.0, SC_NS);

    sc_clock clk("clk", 10, SC_NS, 0.5, 0, SC_NS, true);
    // defining signals
    sc_signal<bool>         resetn;
    sc_signal<bool>         dir;
    sc_signal<uint32_t>     c_out;
    
    sc_trace( sc_tf , clk    , "clk"    );
    sc_trace( sc_tf , resetn , "resetn" );
    sc_trace( sc_tf , dir    , "dir"    );
    sc_trace( sc_tf , c_out  , "c_out"  );
    cout << "Creating dut instance." << endl;
    // creating verilated module for counter design
    Vcounter* sc_counter = new Vcounter("counter_sc");
    // connecting verilated model to testbench signals
    sc_counter->clk    ( clk       );
    sc_counter->resetn ( resetn    );
    sc_counter->dir    ( dir       );
    sc_counter->c_out  ( c_out     );
    cout << "Dut instance created." << endl;
    cout << "Simulation start." << endl;

    resetn.write(0);
    dir.write(0);

    for(int i=0;i<7;i++)
    {
        sc_start(10, SC_NS);
    }

    resetn.write(1);

    for(int i = 0 ; i < 400 ; i++) {
        dir.write(0);
        sc_start(10, SC_NS);
        cout << sc_time_stamp() << ", dir = " << ( dir ? "+" : "-" ) << ", c_out = 0x" << hex << c_out << endl;
    }

    for(int i = 0 ; i < 400 ; i++) {
        dir.write(1);
        sc_start(10, SC_NS);
        cout << sc_time_stamp() << ", dir = " << ( dir ? "+" : "-" ) << ", c_out = 0x" << hex << c_out << endl;
    }

    sc_counter->final();

    delete sc_counter;
    
    sc_close_vcd_trace_file(sc_tf);

    cout << "Simulation end." << endl;

    return 0;
}
