`ifndef UART_COVERAGE__SV
`define UART_COVERAGE__SV

class uart_coverage extends uvm_subscriber #(uart_item);
    
    logic   [7  : 0]    tx_data;
    logic   [1  : 0]    stop;
    logic   [0  : 0]    parity_en;
    integer             baudrate;
    integer             delay;

    `uvm_component_utils(uart_coverage)

    covergroup uart_cg;
        delay_cp : coverpoint delay {
            bins    delay_b [10] = { [100 : 1000] };
        }
        stop_cp : coverpoint stop {
            bins    b_0_5_s = { 2'b00 };
            bins    b_1_0_s = { 2'b01 };
            bins    b_1_5_s = { 2'b10 };
            bins    b_2_0_s = { 2'b11 };
        }
        baudrate_cp : coverpoint baudrate {
            bins    b_9600      = { [9600-7   :   9600+7]};
            bins    b_19200     = { [19200-7  :  19200+7]};
            bins    b_38400     = { [38400-7  :  38400+7]};
            bins    b_57600     = { [57600-7  :  57600+7]};
            bins    b_115200    = { [115200-7 : 115200+7]};
        }
        tx_data_cp : coverpoint tx_data {
            bins    tx_data_b [8] = { [0 : 255] };
        }
    endgroup : uart_cg
    
    extern function new (string name, uvm_component parent);
    extern function void write(uart_item t);

endclass : uart_coverage

function uart_coverage::new (string name, uvm_component parent);
    super.new(name, parent);
    uart_cg = new();
endfunction : new

function void uart_coverage::write(uart_item t);
    string s;

    delay = t.delay;
    stop = t.stop;
    baudrate = t.baudrate;
    tx_data = t.tx_data;
    uart_cg.sample();
    $sformat(s,"Coverage = %2.2f%%", uart_cg.get_coverage());
    `uvm_info
                ( 
                    "UART|COV",
                    s,
                    UVM_LOW
                )
endfunction : write

`endif // UART_COVERAGE__SV
