#ifndef AXI_IF__H
#define AXI_IF__H

#include "systemc.h"
#include "uvm.h"

using namespace uvm;

class axi_if
{
    public:
        // Write address channel
        sc_core::sc_signal< sc_bv<32   > >  AWADDR;
        sc_core::sc_signal< sc_bv<8    > >  AWLEN;
        sc_core::sc_signal< sc_bv<3    > >  AWSIZE;
        sc_core::sc_signal< sc_bv<2    > >  AWBURST;
        sc_core::sc_signal< sc_bv<1    > >  AWVALID;
        sc_core::sc_signal< sc_bv<1    > >  AWREADY;
        // Write data channel
        sc_core::sc_signal< sc_bv<1024 > >  WDATA;
        sc_core::sc_signal< sc_bv<1    > >  WVALID;
        sc_core::sc_signal< sc_bv<1    > >  WREADY;
        // Write response channel
        sc_core::sc_signal< sc_bv<2    > >  BRESP;
        sc_core::sc_signal< sc_bv<1    > >  BVALID;
        sc_core::sc_signal< sc_bv<1    > >  BREADY;
        // Read address channel
        sc_core::sc_signal< sc_bv<32   > >  ARADDR;
        sc_core::sc_signal< sc_bv<8    > >  ARLEN;
        sc_core::sc_signal< sc_bv<3    > >  ARSIZE;
        sc_core::sc_signal< sc_bv<2    > >  ARBURST;
        sc_core::sc_signal< sc_bv<1    > >  ARVALID;
        sc_core::sc_signal< sc_bv<1    > >  ARREADY;
        // Read data channel
        sc_core::sc_signal< sc_bv<1024 > >  RDATA;
        sc_core::sc_signal< sc_bv<2    > >  RRESP;
        sc_core::sc_signal< sc_bv<1    > >  RVALID;
        sc_core::sc_signal< sc_bv<1    > >  RREADY;

    axi_if() {}
};

#endif // AXI_IF__H