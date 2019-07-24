`ifndef APB_IF__SV
`define APB_IF__SV

interface apb_if(input bit pclk, bit rst);

    wire [31 : 0]   paddr;
    wire [0  : 0]   psel;
    wire [0  : 0]   penable;
    wire [0  : 0]   pwrite;
    wire [31 : 0]   prdata;
    wire [31 : 0]   pwdata;

    clocking mck @(posedge pclk);
        output paddr, psel, penable, pwrite, pwdata;
        input prdata;
    endclocking : mck

    clocking sck @(posedge pclk);
        input paddr, psel, penable, pwrite, pwdata;
        output prdata;
    endclocking : sck

    clocking pck @(posedge pclk);
        input paddr, psel, penable, pwrite, prdata, pwdata;
    endclocking : pck

    modport master(clocking mck);
    modport slave(clocking sck);
    modport passive(clocking pck);

endinterface: apb_if

`endif // APB_IF__SV
