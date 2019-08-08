#include "systemc.h"

#include "uart_transmitter_tb.h"

queue<uint32_t> driver_tx_data;
queue<uint32_t> monitor_tx_data;

uart_transmitter_tb *tb = NULL;

int sc_main(int argc, char** argv) {

    cout << "Creating testbench instance." << endl;
    tb = new uart_transmitter_tb( "tb" );
    if( tb == NULL ) {
        cout << "System testbench not created! Simulation failed." << endl;
        return 0;
    }
    cout << "testbench created." << endl;

    cout << "Creating trace file." << endl;
    sc_trace_file* sc_tf;
    sc_tf = sc_create_vcd_trace_file("sc_tb_system");
    sc_tf->set_time_unit(1.0, SC_NS);
    cout << "Trace file created." << endl;

    sc_trace( sc_tf , tb->clk     , "clk"     );
    sc_trace( sc_tf , tb->resetn  , "resetn"  );
    sc_trace( sc_tf , tb->comp    , "comp"    );
    sc_trace( sc_tf , tb->tr_en   , "tr_en"   );
    sc_trace( sc_tf , tb->tx_data , "tx_data" );
    sc_trace( sc_tf , tb->req     , "req"     );
    sc_trace( sc_tf , tb->req_ack , "req_ack" );
    sc_trace( sc_tf , tb->uart_tx , "uart_tx" );
    cout << "Simulation start." << endl;
    sc_start();

    delete tb;

    sc_close_vcd_trace_file(sc_tf);

    for( int i = 0 ; i < 20 ; i++ ){
        uint32_t mon_data = monitor_tx_data.front();
        uint32_t drv_data = driver_tx_data.front();
        monitor_tx_data.pop();
        driver_tx_data.pop();
        if( mon_data == drv_data )
            cout << "Test pass!" << " MON received data = 0x" << mon_data << hex << " DRV received data = 0x" << drv_data << hex << endl;
        else
            cout << "Test fail!" << " MON received data = 0x" << mon_data << hex << " DRV received data = 0x" << drv_data << hex << endl;
    }

    cout << "Simulation end." << endl;

    return 0;

}
