#include "uart_transmitter_driver.h"
/*
    | uart_transmitter_driver       |
    |-------------------|-----------|
    | ports             |  names    |
    |-------------------|-----------|
    | sc_in <bool>      |  clk      |
    | sc_in <bool>      |  resetn   |
    | sc_out<uint32_t>  |  tx_data  |
    | sc_out<uint32_t>  |  comp     |
    | sc_out<bool>      |  tr_en    |
    | sc_out<bool>      |  req      |
    | sc_in <bool>      |  req_ack  |
    ---------------------------------
*/

void uart_transmitter_driver::driver_proc() {
    // start sim
    uint32_t rand_tx_data;
    resetn.write(0);
    tx_data.write(0);
    comp.write(0);
    tr_en.write(0);
    for( int i = 0 ; i < 7 ; i++ ) {
        wait();
    }
    resetn.write(1);
    for(;;) {
        rand_tx_data = rand() % 255;
        tx_data = rand_tx_data;
        cout << "Random tx data = 0x" << rand_tx_data << hex;
        driver_tx_data.push( rand_tx_data );
        switch( rand() % 4 ) {
            case 0:     comp.write( 50000000 / 9600   ); cout << "random baudrate = 9600"   << endl; break;
            case 1:     comp.write( 50000000 / 19200  ); cout << "random baudrate = 19200"  << endl; break;
            case 2:     comp.write( 50000000 / 38400  ); cout << "random baudrate = 38400"  << endl; break;
            case 3:     comp.write( 50000000 / 57600  ); cout << "random baudrate = 57600"  << endl; break;
            case 4:     comp.write( 50000000 / 115200 ); cout << "random baudrate = 115200" << endl; break;
            default:    comp.write( 50000000 / 9600   ); cout << "random baudrate = 9600"   << endl; break;
        }
        tr_en.write(1);
        wait();
        req.write(1);
        wait();
        req.write(0);
        do {
            wait();
        } while( ! req_ack.read() );
        wait();
    }
}
