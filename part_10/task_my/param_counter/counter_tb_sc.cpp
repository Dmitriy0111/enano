
#include "systemc.h"

#include "verilated.h"

#include "../obj_dir/Vcounter.h"

int sc_main(int argc, char* argv[]) {

    int cw = 8;
    int repeat_n = 400;

    if( 0 && argv && argc ) {}
    if (argc > 1) {
		for (int i = 1; i < argc; i++) {
			cout << "Argument " << i << " = " << argv[i] << endl;
			if( strcmp(argv[i] , "-gcw") == 0 ) {
				cw = atoi(argv[i+1]);
                cout << "Counter width overload by " << cw << endl;
            }
			if( strcmp(argv[i] , "-grepeat_n") == 0 ) {
				repeat_n = atoi(argv[i+1]);
                cout << "Repeat number overload by " << repeat_n << endl;
            }
		}
	}

    constexpr int cw_c = 8;

    Verilated::debug(0);

    Verilated::randReset(2);

    Verilated::commandArgs(argc, argv);
    
    ios::sync_with_stdio();

    sc_trace_file* sc_tf;
    sc_tf = sc_create_vcd_trace_file("param_counter");

    sc_time sc_time_(1.0, SC_NS);

    sc_clock clk("clk", 10, SC_NS, 0.5, 3, SC_NS, true);
    // defining signals
    sc_signal<bool>         resetn;
    sc_signal<bool>         dir;
    sc_signal<sc_bv<cw_c>>  c_out;

    sc_trace( sc_tf , clk    , "clk"    );
    sc_trace( sc_tf , resetn , "resetn" );
    sc_trace( sc_tf , dir    , "dir"    );
    sc_trace( sc_tf , c_out  , "c_out"  );
    // creating verilated module for counter design
    Vcounter*<cw_c> sc_counter = new Vcounter("counter_sc");
    // connecting verilated model to testbench signals
    sc_counter->clk    ( clk       );
    sc_counter->resetn ( resetn    );
    sc_counter->dir    ( dir       );
    sc_counter->c_out  ( c_out     );

    sc_start();

    resetn = 0;
    dir = 0;

    for(int i=0;i<7;i++)
    {
        wait();
    }

    resetn = 1;

    for(int i = 0 ; i < repeat_n ; i++) {
        dir = 0;
        wait();
        cout << sc_time_stamp() << ", dir = " << ( dir ? "+" : "-" ) << ", c_out = 0x" << hex << c_out << endl;
    }

    for(int i = 0 ; i < repeat_n ; i++) {
        dir = 1;
        wait();
        cout << sc_time_stamp() << ", dir = " << ( dir ? "+" : "-" ) << ", c_out = 0x" << hex << c_out << endl;
    }

    sc_stop();

    sc_counter->final();

    delete sc_counter;
    
    sc_close_vcd_trace_file(sc_tf);

    return 0;
}
