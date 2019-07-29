`ifndef AHB_IF__SV
`define AHB_IF__SV

//  Interface: ahb_if
//
interface ahb_if(logic [0 : 0] HCLK, logic [0 : 0] HRESETN);

    logic   [31 : 0]    HADDR;
    logic   [31 : 0]    HRDATA;
    logic   [31 : 0]    HWDATA;
    logic   [0  : 0]    HWRITE;
    logic   [1  : 0]    HTRANS;
    logic   [2  : 0]    HSIZE;
    logic   [3  : 0]    HPROT;
    logic   [2  : 0]    HBURST;
    logic   [0  : 0]    HMASTLOCK;
    logic   [0  : 0]    HREADY;
    logic   [0  : 0]    HRESP;
    
endinterface : ahb_if

`endif // AHB_IF__SV
