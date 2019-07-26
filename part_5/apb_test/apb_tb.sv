import uvm_pkg::*;
`include "uvm_macros.svh"

import apb_test_pkg::*;

module apb_tb;

    typedef virtual apb_if apb_vif;

    logic   [0 : 0]     clk;
    logic   [0 : 0]     resetn;

    apb_if      apb_if_(clk, resetn);

    initial
    begin
        clk = '1;
        forever
            #(10) clk = !clk;
    end

    initial begin
        uvm_config_db#(apb_vif)::set(uvm_root::get(), "uvm_test_top.env", "apb_vif", apb_if_);
        run_test(  );
    end

endmodule : apb_tb
