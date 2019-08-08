#include "systemc.h"
#include "ram.h"

void make_clk(sc_signal<bool>* clk) {
    clk->write(0);    
    sc_start(10, SC_NS);
    clk->write(1);
    sc_start(10, SC_NS);
}

int sc_main(int argc, char** argv) {

    sc_trace_file* sc_tf;
    sc_tf = sc_create_vcd_trace_file("ram_test");
    sc_tf->set_time_unit(1.0, SC_NS);

    sc_time sc_time_(1.0,SC_NS);
    sc_set_default_time_unit(1.0,SC_NS);

    sc_signal<bool>     clk;
    sc_signal<sc_lv<8>> addr;
    sc_signal<sc_lv<8>> wd;
    sc_signal<bool>     we;
    sc_signal<sc_lv<8>> rd;

    sc_lv<8>            test_mem[256];

    ram* sc_ram = new ram("sc_ram");

    sc_ram->clk     ( clk       );
    sc_ram->addr    ( addr      );
    sc_ram->wd      ( wd        );
    sc_ram->we      ( we        );
    sc_ram->rd      ( rd        );

    cout << "Simulation start." << endl;

    uint32_t test_data;
    bool     test_we;

    we.write(0);
    addr.write(0);
    wd.write(0);
    make_clk(&clk);

    for( int i = 0 ; i < 256 ; i++ ) {
        test_data = rand() % 255;
        test_we = rand() % 1;
        wd.write( test_data );
        we.write( test_we );
        if( test_we )
            test_mem[i] = test_data;
        make_clk( &clk );
        we.write( 0 );
    }

    for( int i = 0 ; i < 255 ; i++ )
        cout << "ram mem[" << i << "] = 0x" << sc_ram.mem[i] << ", test mem[" << i << "] = 0x" << test_mem[i] << endl;

    delete sc_ram;
    
    sc_close_vcd_trace_file(sc_tf);

    cout << "Simulation end." << endl;

    return 0;

}
