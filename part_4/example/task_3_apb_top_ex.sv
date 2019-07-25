module top();

    import      uvm_pkg::*;
    `include    "uvm_macros.svh"
    
    import task_3_apb_pkg_ex::*;
    
    reg         clk_i;
    reg         rst;
    real        freq = 3000000;
    real        half_peri = 1000000000/(2*freq);
    wire        clk;

    typedef virtual apb_if apb_vif; 

    always #(half_peri) clk_i = ~clk_i;

    assign clk = clk_i;

    initial 
    begin
        clk_i = 0;
        rst = 1;
    end

    apb_if apb0(clk,rst);

    initial 
    begin
        uvm_config_db#(apb_vif)::set(uvm_root::get(), "uvm_test_top.env", "apb_vif", apb0);
    end
    initial 
    begin
        run_test("run_item_test");
    end
    initial 
    begin
        $dumpfile ("dump.vcd");
    end

endmodule : top
