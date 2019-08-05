#include "uart_transmitter_monitor.h"
/*
    | uart_transmitter_monitor      |
    |-------------------|-----------|
    | ports             |  names    |
    |-------------------|-----------|
    | sc_in <bool>      |  clk      |
    | sc_in <bool>      |  resetn   |
    | sc_in <uint32_t>  |  comp     |
    | sc_in <bool>      |  uart_tx  |
    ---------------------------------
*/

void uart_transmitter_monitor::monitor_proc(); {
    uint32_t rec_data = 0;
    uint32_t comp_v = 0;
    for(;;;) {
        do {
            wait(10, SC_NS);
        } while( uart_tx != false )
        comp_v = comp;
        rec_data = 0;
        // Start
        for( int i = 0 ; i < comp_v ; i++ ) {
            wait(10, SC_NS);
        }
        // Receive data
        for( int j = 0 ; j < 8 ; j++ ){
            for( int i = 0 ; i < comp_v / 2 ; i++ ) {
                wait(10, SC_NS);
            }
            rec_data |= ( ( uart_tx == true ) ? 1 : 0 ) << j;
            for( int i = 0 ; i < comp_v / 2 ; i++ ) {
                wait(10, SC_NS);
            }
        }
        // Stop
        for( int i = 0 ; i < comp_v ; i++ ) {
            wait(10, SC_NS);
        }
        cout << "Receive data = 0x" << rec_data << hex << endl;
    }
}