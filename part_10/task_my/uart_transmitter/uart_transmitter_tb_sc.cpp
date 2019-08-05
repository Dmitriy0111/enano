#include "systemc.h"

#include "verilated.h"

#include "../obj_dir/Vuart_transmitter.h"
#include "uart_transmitter_driver.h"
#include "uart_transmitter_monitor.h"

void clean_signals(sc_signal<bool>* resetn, sc_signal<uint32_t>* comp, sc_signal<bool>* tr_en, sc_signal<uint32_t>* tx_data, sc_signal<bool>* req){
    *resetn = false;
    *tr_en = false;
    *req = false;
    *comp = 0;
    *tx_data = 0;
}

int sc_main(int argc, char** argv) {

    Verilated::debug(0);
    Verilated::randReset(2);
    Verilated::commandArgs(argc,argv);

    ios::sync_with_stdio();

    sc_trace_file* sc_tf;
    sc_tf = sc_create_vcd_trace_file("uart_transmitter.vcd");

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

    Vuart_transmitter* sc_dut = new Vuart_transmitter("sc_dut");
    uart_transmitter_driver* sc_drv = new uart_transmitter_driver("sc_drv");
    uart_transmitter_monitor* sc_mon = new uart_transmitter_monitor("sc_mon");

    sc_dut->clk     ( clk       );
    sc_dut->resetn  ( resetn    );
    sc_dut->comp    ( comp      );
    sc_dut->tr_en   ( tr_en     );
    sc_dut->tx_data ( tx_data   );
    sc_dut->req     ( req       );
    sc_dut->req_ack ( req_ack   );
    sc_dut->uart_tx ( uart_tx   );

    sc_drv->clk     ( clk       );
    sc_drv->resetn  ( resetn    );
    sc_drv->tx_data ( tx_data   );
    sc_drv->comp    ( comp      );
    sc_drv->tr_en   ( tr_en     );
    sc_drv->req     ( req       );
    sc_drv->req_ack ( req_ack   );

    sc_mon->uart_tx ( uart_tx   );
    sc_mon->clk     ( clk       );
    sc_mon->resetn  ( resetn    );
    sc_mon->comp    ( comp      );

    resetn = 0;
    clean_signals(&resetn, &comp, &tr_en, &tx_data, &req);

    for(int i=0;i<7;i++)
    {
        sc_start(10, SC_NS);
    }

    resetn = 1;

    sc_dut->final();

    delete sc_dut;
    sc_dut = NULL;

    sc_close_vcd_file(sc_tf);

    return 0;

}
