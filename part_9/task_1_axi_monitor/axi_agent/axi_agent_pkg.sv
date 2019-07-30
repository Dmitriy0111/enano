`ifndef AXI_AGENT_PKG__SV
`define AXI_AGENT_PKG__SV

//  Package: axi_agent_pkg
//
package axi_agent_pkg;
    
    import uvm_pkg::*;

    `include "uvm_macros.svh"
    
    `include "axi_item.sv"
    `include "axi_agent_cfg.sv"
    `include "axi_monitor.sv"
    `include "axi_driver.sv"
    `include "axi_base_seq.sv"
    `include "axi_rand_seq.sv"
    `include "axi_sequencer.sv"
    `include "axi_agent.sv"
    
endpackage : axi_agent_pkg

`endif // AXI_AGENT_PKG__SV
