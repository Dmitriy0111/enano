#include "systemc.h"

#include "verilated.h"

#include "../obj_dir/Vuart_transmitter.h"
#include "uart_transmitter_driver.h"
#include "uart_transmitter_monitor.h"
#include <queue>

using namespace std;

queue<uint32_t> driver_tx_data;
queue<uint32_t> monitor_tx_data;

int sc_main(int argc, char** argv) {

    Verilated::debug(0);
    Verilated::randReset(2);
    Verilated::commandArgs(argc,argv);

    ios::sync_with_stdio();

    sc_trace_file* sc_tf;
    sc_tf = sc_create_vcd_trace_file("uart_transmitter");

    sc_time sc_time_(1.0, SC_NS);

    sc_clock clk("clk", 10, SC_NS, 0.5, 3, SC_NS, true);

    sc_signal<bool>     resetn;
    sc_signal<uint32_t> comp;
    sc_signal<bool>     tr_en;
    sc_signal<uint32_t> tx_data;
    sc_signal<bool>     req;
    sc_signal<bool>     req_ack;
    sc_signal<bool>     uart_tx;
    
    sc_trace( sc_tf , clk     , "clk"     );
    sc_trace( sc_tf , resetn  , "resetn"  );
    sc_trace( sc_tf , comp    , "comp"    );
    sc_trace( sc_tf , tr_en   , "tr_en"   );
    sc_trace( sc_tf , tx_data , "tx_data" );
    sc_trace( sc_tf , req     , "req"     );
    sc_trace( sc_tf , req_ack , "req_ack" );
    sc_trace( sc_tf , uart_tx , "uart_tx" );

    // Creating design under test and connect to signals
    Vuart_transmitter* sc_dut = new Vuart_transmitter("sc_dut");
    sc_dut->clk     ( clk       );
    sc_dut->resetn  ( resetn    );
    sc_dut->comp    ( comp      );
    sc_dut->tr_en   ( tr_en     );
    sc_dut->tx_data ( tx_data   );
    sc_dut->req     ( req       );
    sc_dut->req_ack ( req_ack   );
    sc_dut->uart_tx ( uart_tx   );
    // Creating driver and connect to signals
    uart_transmitter_driver* sc_drv = new uart_transmitter_driver("sc_drv");
    sc_drv->clk     ( clk       );
    sc_drv->resetn  ( resetn    );
    sc_drv->tx_data ( tx_data   );
    sc_drv->comp    ( comp      );
    sc_drv->tr_en   ( tr_en     );
    sc_drv->req     ( req       );
    sc_drv->req_ack ( req_ack   );
    // Creating monitor and connect to signals
    uart_transmitter_monitor* sc_mon = new uart_transmitter_monitor("sc_mon");
    sc_mon->uart_tx ( uart_tx   );
    sc_mon->clk     ( clk       );
    sc_mon->resetn  ( resetn    );
    sc_mon->comp    ( comp      );

    sc_start();

    sc_dut->final();

    delete sc_dut;
    delete sc_mon;
    delete sc_drv;

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

    sc_close_vcd_trace_file(sc_tf);

    return 0;

}
