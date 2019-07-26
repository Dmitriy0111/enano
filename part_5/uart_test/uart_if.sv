`ifndef UART_IF__SV
`define UART_IF__SV

interface uart_if(input bit clk, bit resetn);

    logic   [7  : 0]    tx_data;    // transmitted data
    logic   [1  : 0]    stop;       // number of stop bits
    logic   [0  : 0]    parity_en;  // parity enable field
    logic   [15 : 0]    baudrate;   // selected baudrate
    logic   [0  : 0]    req;        // request
    logic   [0  : 0]    req_ack;    // request ack
    logic   [0  : 0]    uart_tx;

    clocking mck @(posedge clk);
        output  tx_data;
        output  stop;
        output  parity_en;
        output  baudrate;
        output  req;
        input   req_ack;
        input   uart_tx;
    endclocking : mck

    clocking sck @(posedge clk);
        input   tx_data;
        input   stop;
        input   parity_en;
        input   baudrate;
        input   req;
        output  req_ack;
        input   uart_tx;
    endclocking : sck

    clocking pck @(posedge clk);
        input tx_data;
        input stop;
        input parity_en;
        input baudrate;
        input req;
        input req_ack;
        input uart_tx;
    endclocking : pck

    modport master  (clocking mck);
    modport slave   (clocking sck);
    modport passive (clocking pck);

endinterface : uart_if

`endif
