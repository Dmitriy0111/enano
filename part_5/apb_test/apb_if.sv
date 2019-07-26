`ifndef APB_IF__SV
`define APB_IF__SV

interface apb_if#(parameter addrw = 32, parameter dataw = 32)(input bit pclk, bit presetn);

    logic   [addrw-1 : 0]   paddr;
    logic   [dataw-1 : 0]   prdata;
    logic   [dataw-1 : 0]   pwdata;
    logic   [0       : 0]   pwrite;
    logic   [0       : 0]   psel;
    logic   [0       : 0]   penable;

    clocking mck @(posedge pclk);
        output  paddr;
        output  psel;
        output  penable;
        output  pwrite;
        output  pwdata;
        input   prdata;
    endclocking : mck

    clocking sck @(posedge pclk);
        input   paddr;
        input   psel;
        input   penable;
        input   pwrite;
        input   pwdata;
        output  prdata;
    endclocking : sck

    clocking pck @(posedge pclk);
        input   paddr;
        input   psel;
        input   penable;
        input   pwrite;
        input   pwdata;
        input   prdata;
    endclocking : pck

endinterface : apb_if

`endif // APB_IF__SV
