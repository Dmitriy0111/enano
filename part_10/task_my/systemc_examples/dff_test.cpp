#include "systemc.h"
#include "dff.h"

#define dw 10

void make_clk(sc_signal<bool>* clk) {
    clk->write(0);    
    sc_start(10, SC_NS);
    clk->write(1);
    sc_start(10, SC_NS);
}

int sc_main(int argc, char** argv) {

    sc_trace_file* sc_tf;
    sc_tf = sc_create_vcd_trace_file("dff_test");
    sc_tf->set_time_unit(1.0, SC_NS);

    sc_time sc_time_(1.0,SC_NS);
    sc_set_default_time_unit(1.0,SC_NS);

    sc_signal<bool>         clk;
    sc_signal<bool>         resetn;
    sc_signal<sc_lv<dw>>    din;
    sc_signal<sc_lv<dw>>    dout;

    dff<dw>* sc_dff = new dff<dw>("sc_dff");

    sc_dff->clk     ( clk       );
    sc_dff->resetn  ( resetn    );
    sc_dff->din     ( din       );
    sc_dff->dout    ( dout      );

    cout << "Simulation start." << endl;

    din.write(0);
    resetn.write(0);

    for( int i = 0 ; i < 7 ; i++ ) {
        make_clk( &clk );
    }

    resetn.write(1);

    for( int i = 0 ; i < 256 ; i++ ) {
        din.write( rand() % 1023 );
        make_clk( &clk );
    }

    delete sc_dff;
    
    sc_close_vcd_trace_file(sc_tf);

    cout << "Simulation end." << endl;

    return 0;

}
