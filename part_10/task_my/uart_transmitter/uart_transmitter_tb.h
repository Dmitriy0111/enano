#include "systemc.h"

#include "verilated.h"

#include "uart_transmitter_driver.cpp"
#include "uart_transmitter_monitor.cpp"
#include "../obj_dir/Vuart_transmitter.h"

SC_MODULE( uart_transmitter_tb ) {
    uart_transmitter_driver     *drv;
    uart_transmitter_monitor    *mon;
    Vuart_transmitter           *dut;

    sc_signal<bool>             resetn;
    sc_signal<uint32_t>         comp;
    sc_signal<bool>             tr_en;
    sc_signal<uint32_t>         tx_data;
    sc_signal<bool>             req;
    sc_signal<bool>             req_ack;
    sc_signal<bool>             uart_tx;

    sc_clock                    clk;

    SC_CTOR( uart_transmitter_tb ) : clk("clk", 10, SC_NS) {
        // Creating driver and connect to signals
        drv = new uart_transmitter_driver( "drv" );
        drv->clk        ( clk       );
        drv->resetn     ( resetn    );
        drv->tx_data    ( tx_data   );
        drv->comp       ( comp      );
        drv->tr_en      ( tr_en     );
        drv->req        ( req       );
        drv->req_ack    ( req_ack   );
        // Creating monitor and connect to signals
        mon = new uart_transmitter_monitor( "mon" );
        mon->uart_tx    ( uart_tx   );
        mon->clk        ( clk       );
        mon->resetn     ( resetn    );
        mon->comp       ( comp      );
        // Creating design under test and connect to signals
        dut = new Vuart_transmitter( "dut" );
        dut->clk        ( clk       );
        dut->resetn     ( resetn    );
        dut->comp       ( comp      );
        dut->tr_en      ( tr_en     );
        dut->tx_data    ( tx_data   );
        dut->req        ( req       );
        dut->req_ack    ( req_ack   );
        dut->uart_tx    ( uart_tx   );
    }

    ~uart_transmitter_tb() {
        delete dut;
        delete drv;
        delete mon;
    }
    
};
