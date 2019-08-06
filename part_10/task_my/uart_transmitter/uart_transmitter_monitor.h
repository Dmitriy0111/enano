#include "systemc.h"

SC_MODULE( uart_transmitter_monitor ) {
    sc_in   <bool>      clk;
    sc_in   <bool>      resetn;
    sc_in   <uint32_t>  comp;
    sc_in   <bool>      uart_tx;

    void monitor_proc();

    SC_CTOR(uart_transmitter_monitor){
        SC_THREAD( monitor_proc , clk.pos() );
    }
}
