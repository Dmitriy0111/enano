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

void uart_transmitter_monitor::monitor_proc() {
    uint32_t rec_data = 0;
    uint32_t comp_v = 0;
    do{
        wait();
    } while( ! resetn.read() );
    for( int c = 0 ; c < 20 ; c++ ) {
        do {
            wait();
        } while( uart_tx != false );
        comp_v = comp;
        rec_data = 0;
        // Start
        for( int i = 0 ; i < comp_v ; i++ ) {
            wait();
        }
        // Receive data
        for( int j = 0 ; j < 8 ; j++ ){
            for( int i = 0 ; i < comp_v / 2 ; i++ ) {
                wait();
            }
            rec_data |= ( ( uart_tx == true ) ? 1 : 0 ) << j;
            for( int i = 0 ; i < comp_v / 2 ; i++ ) {
                wait();
            }
        }
        // Stop
        for( int i = 0 ; i < comp_v ; i++ ) {
            wait();
        }
        cout << "Receive data = 0x" << rec_data << hex << endl;
    }
    sc_stop();
}
