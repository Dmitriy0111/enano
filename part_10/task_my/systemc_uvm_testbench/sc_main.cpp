#include "systemc.h"
#include "uvm.h"

#include "axi_base_test.h"
#include "axi_if.h"

int sc_main(int argc, char*[] argv) {  

    sc_trace_file* sc_tf;
    sc_tf = sc_create_vcd_trace_file("systemc_uvm_testbench");

    axi_if* vif = new axi_if();

    sc_trace( sc_tf , vif->AWADDR  , "vif.AWADDR"  );
    sc_trace( sc_tf , vif->AWLEN   , "vif.AWLEN"   );
    sc_trace( sc_tf , vif->AWSIZE  , "vif.AWSIZE"  );
    sc_trace( sc_tf , vif->AWBURST , "vif.AWBURST" );
    sc_trace( sc_tf , vif->AWVALID , "vif.AWVALID" );
    sc_trace( sc_tf , vif->AWREADY , "vif.AWREADY" );
    sc_trace( sc_tf , vif->WDATA   , "vif.WDATA"   );
    sc_trace( sc_tf , vif->WVALID  , "vif.WVALID"  );
    sc_trace( sc_tf , vif->WREADY  , "vif.WREADY"  );
    sc_trace( sc_tf , vif->BRESP   , "vif.BRESP"   );
    sc_trace( sc_tf , vif->BVALID  , "vif.BVALID"  );
    sc_trace( sc_tf , vif->BREADY  , "vif.BREADY"  );
    sc_trace( sc_tf , vif->ARADDR  , "vif.ARADDR"  );
    sc_trace( sc_tf , vif->ARLEN   , "vif.ARLEN"   );
    sc_trace( sc_tf , vif->ARSIZE  , "vif.ARSIZE"  );
    sc_trace( sc_tf , vif->ARBURST , "vif.ARBURST" );
    sc_trace( sc_tf , vif->ARVALID , "vif.ARVALID" );
    sc_trace( sc_tf , vif->ARREADY , "vif.ARREADY" );
    sc_trace( sc_tf , vif->RDATA   , "vif.RDATA"   );
    sc_trace( sc_tf , vif->RRESP   , "vif.RRESP"   );
    sc_trace( sc_tf , vif->RVALID  , "vif.RVALID"  );
    sc_trace( sc_tf , vif->RREADY  , "vif.RREADY"  );

    uvm::uvm_config_db<axi_if*>::set(0, "uvm_test_top.env.agent_0.*", "vif", vif);

    uvm::run_test("axi_base_test");

    delete vif;

    sc_close_vcd_trace_file(sc_tf);

    return 0;
}
