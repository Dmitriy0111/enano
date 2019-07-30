`ifndef AXI_IF__SV
`define AXI_IF__SV

//  Interface: axi_if
//
interface axi_if(input bit [0 : 0] ACLK, bit [0 : 0] ARESETN);

    // Write address channel
    logic   [31   : 0]  AWADDR;
    logic   [7    : 0]  AWLEN;
    logic   [2    : 0]  AWSIZE;
    logic   [1    : 0]  AWBURST;
    logic   [0    : 0]  AWVALID;
    logic   [0    : 0]  AWREADY;
    // Write data channel
    logic   [1023 : 0]  WDATA;
    logic   [0    : 0]  WVALID;
    logic   [0    : 0]  WREADY;
    // Write response channel
    logic   [1    : 0]  BRESP;
    logic   [0    : 0]  BVALID;
    logic   [0    : 0]  BREADY;
    // Read address channel
    logic   [31   : 0]  ARADDR;
    logic   [7    : 0]  ARLEN;
    logic   [2    : 0]  ARSIZE;
    logic   [1    : 0]  ARBURST;
    logic   [0    : 0]  ARVALID;
    logic   [0    : 0]  ARREADY;
    // Read data channel
    logic   [1023 : 0]  RDATA;
    logic   [1    : 0]  RRESP;
    logic   [0    : 0]  RVALID;
    logic   [0    : 0]  RREADY;
    
endinterface : axi_if

`endif // AXI_IF__SV
