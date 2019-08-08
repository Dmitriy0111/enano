#include "systemc.h"
#include <queue>

using namespace std;

extern queue<uint32_t> driver_tx_data;

SC_MODULE( uart_transmitter_driver ) {
    sc_in   <bool>      clk;
    sc_out  <bool>      resetn;
    sc_out  <uint32_t>  tx_data;
    sc_out  <uint32_t>  comp;
    sc_out  <bool>      tr_en;
    sc_out  <bool>      req;
    sc_in   <bool>      req_ack;

    void driver_proc();

    SC_CTOR(uart_transmitter_driver){
        SC_THREAD( driver_proc );
        sensitive_pos( clk );
    }
};
