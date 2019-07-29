`ifndef APB_IF__SV
`define APB_IF__SV

//  Interface: apb_if
//
interface apb_if(logic [0 : 0] PCLK, logic[0 : 0] PRESETN);

    logic   [31 : 0]    PADDR;
    logic   [31 : 0]    PRDATA;
    logic   [31 : 0]    PWDATA;
    logic   [0  : 0]    PWRITE;
    logic   [0  : 0]    PSEL;
    logic   [0  : 0]    PENABLE;

endinterface : apb_if

`endif // APB_IF__SV
