#include "systemc.h"

#include "uart_transmitter_tb.h"

uart_transmitter_tb *tb = NULL;

int sc_main(int argc, char** argv) {

    tb = new uart_transmitter_tb( "tb" );
    if( tb == NULL ) {
        cout << "System testbench not created! Simulation failed." << endl;
        return 0;
    }
    sc_trace_file* sc_tf;
    sc_tf = sc_create_vcd_trace_file("sc_tb_system");
    
    sc_trace( sc_tf , tb->clk     , "clk"     );
    sc_trace( sc_tf , tb->resetn  , "resetn"  );
    sc_trace( sc_tf , tb->comp    , "comp"    );
    sc_trace( sc_tf , tb->tr_en   , "tr_en"   );
    sc_trace( sc_tf , tb->tx_data , "tx_data" );
    sc_trace( sc_tf , tb->req     , "req"     );
    sc_trace( sc_tf , tb->req_ack , "req_ack" );
    sc_trace( sc_tf , tb->uart_tx , "uart_tx" );

    sc_start();

    sc_close_vcd_trace_file(sc_tf);

    delete tb;

    return 0;

}
