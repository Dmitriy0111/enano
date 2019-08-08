#ifndef DFF__H
#define DFF__H

#include "systemc.h"
template <int dw = 8>
SC_MODULE( dff ) {
    public:
    sc_in   <bool>          clk;
    sc_in   <bool>          resetn;
    sc_in   <sc_lv<dw>>     din;
    sc_out  <sc_lv<dw>>     dout;

    void proc() {
        if( !resetn ) {
            dout.write(0);
        } else if( clk.event() ) {
            dout = din;
        }
    };

    SC_CTOR( dff ) {
        SC_METHOD( proc );
        sensitive( resetn );
        sensitive_pos( clk );
    }
};

#endif // DFF__H
