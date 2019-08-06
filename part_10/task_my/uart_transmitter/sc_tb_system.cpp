#include "systemc.h"

#include "system.h"

system *system_p = NULL;

int sc_main(int argc, char** argv) {

    system_p = new system( "system_p" );
    if( system_p == NULL ) {
        cout << "System testbench not created! Simulation failed." << endl;
        return 0;
    }
    sc_trace_file* sc_tf;
    sc_tf = sc_create_vcd_trace_file("sc_tb_system");
    
    sc_trace( sc_tf , system_p->clk     , "clk"     );
    sc_trace( sc_tf , system_p->resetn  , "resetn"  );
    sc_trace( sc_tf , system_p->comp    , "comp"    );
    sc_trace( sc_tf , system_p->tr_en   , "tr_en"   );
    sc_trace( sc_tf , system_p->tx_data , "tx_data" );
    sc_trace( sc_tf , system_p->req     , "req"     );
    sc_trace( sc_tf , system_p->req_ack , "req_ack" );
    sc_trace( sc_tf , system_p->uart_tx , "uart_tx" );

    sc_start();

    sc_close_vcd_trace_file(sc_tf);

    return 0;

}
