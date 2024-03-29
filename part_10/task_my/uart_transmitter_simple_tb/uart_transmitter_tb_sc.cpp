#include "systemc.h"

#include "verilated.h"

#include "../obj_dir/Vuart_transmitter.h"

void clean_signals(sc_signal<bool>* resetn, sc_signal<uint32_t>* comp, sc_signal<bool>* tr_en, sc_signal<uint32_t>* tx_data, sc_signal<bool>* req) {
    resetn->write(0);
    tr_en->write(0);
    req->write(0);
    comp->write(0);
    tx_data->write(0);
}

void write_uart(sc_signal<uint32_t>* comp, sc_signal<bool>* tr_en, sc_signal<uint32_t>* tx_data, sc_signal<bool>* req, sc_signal<bool>* req_ack) {
    int delay = 0;
    delay = rand() %200;
    tx_data->write( rand() % 255 );
    cout << "Random tx data = 0x" << *tx_data << hex;
    switch( rand() % 4 ) {
        case 0:     comp->write( 50000000 / 9600   ); cout << "random baudrate = 9600"   << endl; break;
        case 1:     comp->write( 50000000 / 19200  ); cout << "random baudrate = 19200"  << endl; break;
        case 2:     comp->write( 50000000 / 38400  ); cout << "random baudrate = 38400"  << endl; break;
        case 3:     comp->write( 50000000 / 57600  ); cout << "random baudrate = 57600"  << endl; break;
        case 4:     comp->write( 50000000 / 115200 ); cout << "random baudrate = 115200" << endl; break;
        default:    comp->write( 50000000 / 9600   ); cout << "random baudrate = 9600"   << endl; break;
    }
    for( delay ; delay > 0 ; delay-- ) {
        sc_start(10, SC_NS);
    }
    tr_en->write(1);
    req->write(1);
    sc_start(10, SC_NS);
    req->write(0);
    do {
        sc_start(10, SC_NS);
    } while( ! req_ack->read() );
    sc_start(10, SC_NS);
}

int sc_main(int argc, char** argv) {

    int repeat_c = 20;

    Verilated::debug(0);
    Verilated::randReset(2);
    Verilated::commandArgs(argc,argv);

    ios::sync_with_stdio();
    cout << "Creating trace file." << endl;
    sc_trace_file* sc_tf;
    sc_tf = sc_create_vcd_trace_file("uart_transmitter");
    sc_tf->set_time_unit(1.0, SC_NS);
    cout << "Trace file created." << endl;

    sc_time sc_time_(1.0, SC_NS);

    sc_clock clk("clk", 10, SC_NS, 0.5, 0, SC_NS, true);

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

    cout << "Creating dut instance." << endl;
    Vuart_transmitter* sc_dut = new Vuart_transmitter("sc_dut");
    sc_dut->clk     ( clk       );
    sc_dut->resetn  ( resetn    );
    sc_dut->comp    ( comp      );
    sc_dut->tr_en   ( tr_en     );
    sc_dut->tx_data ( tx_data   );
    sc_dut->req     ( req       );
    sc_dut->req_ack ( req_ack   );
    sc_dut->uart_tx ( uart_tx   );

    cout << "Dut instance created." << endl;
    cout << "Simulation start." << endl;

    resetn.write(0);
    clean_signals(&resetn, &comp, &tr_en, &tx_data, &req);

    for(int i=0;i<7;i++)
    {
        sc_start(10, SC_NS);
    }

    resetn.write(1);

    for( int i = 0 ; i < repeat_c ; i++ ) {
        write_uart(&comp, &tr_en, &tx_data, &req, &req_ack);
    }

    sc_dut->final();

    delete sc_dut;

    sc_close_vcd_trace_file(sc_tf);

    cout << "Simulation end." << endl;

    return 0;

}
