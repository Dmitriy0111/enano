#ifndef RAM__H
#define RAM__H

#include "systemc.h"

SC_MODULE( ram ) {
    sc_in   <bool>      clk;
    sc_in   <sc_lv<8>>  addr;
    sc_in   <sc_lv<8>>  wd;
    sc_in   <bool>      we;
    sc_out  <sc_lv<8>>  rd;

    sc_lv<8>    mem[256];

    void read_data() {
        rd = mem[addr.read()];
    };
    void write_data() {
        if( clk.event() ){
            if( we ) {
                mem[addr.read()] = wd;
            }
        }
    };

    SC_CTOR( ram ) {
        SC_METHOD( read_data  );
        sensitive << addr << rd;
        SC_METHOD( write_data );
        sensitive_pos( clk );
        sensitive << addr << we << wd;
    }

};

#endif // RAM__H
