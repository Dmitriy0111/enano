import uvm_pkg::*;
`include "uvm_macros.svh"

import axi_test_pkg::*;

module axi_tb;

    typedef virtual axi_if axi_vif;

    logic   [0 : 0]     aclk;
    logic   [0 : 0]     aresetn;

    axi_if      axi_if_(aclk, aresetn);

    initial
    begin
        aclk = '1;
        forever
            #(10) aclk = !aclk;
    end

    initial 
    begin
        uvm_config_db#(axi_vif)::set(uvm_root::get(), "uvm_test_top.env", "axi_vif", axi_if_);
        uvm_config_db#(axi_vif)::set(uvm_root::get(), "uvm_test_top", "axi_vif", axi_if_);
        run_test(  );
    end

endmodule : axi_tb
