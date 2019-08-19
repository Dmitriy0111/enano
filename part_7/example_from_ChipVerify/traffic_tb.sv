module traffic_tb();

    `include "uvm_macros.svh"
    import uvm_pkg::*;

    import my_pkg::*;

    typedef virtual bus_if bus_vif;

    logic   [0 : 0]     pclk;

    bus_if              bus_if_0(pclk);

    traffic 
    traffic_0
    (  
        .pclk       ( pclk              ),
        .presetn    ( bus_if_0.presetn  ),
        .paddr      ( bus_if_0.paddr    ),
        .pwdata     ( bus_if_0.pwdata   ),
        .psel       ( bus_if_0.psel     ),
        .pwrite     ( bus_if_0.pwrite   ),
        .penable    ( bus_if_0.penable  ),
        .prdata     ( bus_if_0.prdata   )
    );

    initial
    begin
        pclk = '0;
        forever
            #(10) pclk = !pclk;
    end
    initial
    begin
        bus_if_0.presetn = '0;
        @(posedge pclk);
        bus_if_0.presetn = '1;
    end

    initial begin
        uvm_config_db#(bus_vif)::set(uvm_root::get(), "uvm_test_top.m_env.m_agent.m_drvr", "bus_vif", bus_if_0);
        uvm_config_db#(bus_vif)::set(uvm_root::get(), "uvm_test_top.m_env.m_agent.m_mon", "bus_vif", bus_if_0);
        uvm_config_db#(bus_vif)::set(uvm_root::get(), "uvm_test_top.m_env.m_agent.m_seqr", "bus_vif", bus_if_0);
        run_test( "reg_rw_test" );
    end

endmodule : traffic_tb
