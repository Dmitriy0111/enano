#include "systemc.h"

SC_MODULE( uart_transmitter_driver ) {
    sc_in   <bool>      clk;
    sc_in   <bool>      resetn;
    sc_out  <uint32_t>  tx_data;
    sc_out  <uint32_t>  comp;
    sc_out  <bool>      tr_en;
    sc_out  <bool>      req;
    sc_in   <bool>      req_ack;

    void driver_proc();

    SC_CTOR(uart_transmitter_driver){
        SC_THREAD( driver_proc , clk.pos() );
    }
}
