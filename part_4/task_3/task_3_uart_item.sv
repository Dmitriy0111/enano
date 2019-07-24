`ifndef UART_ITEM__SV
`define UART_ITEM__SV

import      uvm_pkg::*;
`include    "uvm_macros.svh"

import task_3_uart_pkg::*;

class uart_item extends uvm_sequence_item;

    rand    logic   [7  : 0]    tx_data;
    rand    logic   [1  : 0]    stop;
    rand    logic   [0  : 0]    parity_en;
    rand    integer             baudrate;
    rand    integer             delay;

    `uvm_object_utils_begin(uart_item)
        `uvm_field_int( tx_data   , UVM_DEFAULT | UVM_HEX );
        `uvm_field_int( stop      , UVM_DEFAULT | UVM_HEX );
        `uvm_field_int( parity_en , UVM_DEFAULT | UVM_HEX );
        `uvm_field_int( baudrate  , UVM_DEFAULT | UVM_DEC );
        `uvm_field_int( delay     , UVM_DEFAULT | UVM_DEC );
    `uvm_object_utils_end

    constraint baudrate_c {
        //baudrate inside { 9600 , 19200 , 38400 , 57600 , 115200 };
        baudrate inside { 115200 };
    }

    constraint delay_c {
        delay < 1000;
        delay > 0;
    }

    function new(string name = "uart_item");
        super.new(name);
    endfunction : new

    function string convert2string();
        string s;
        $sformat(   s,
                    "| tx_data = 0x%h | stop = 0b%b(%s) | parity_en = 0b%b | baudrate = %d | delay = %d |",
                    tx_data,
                    stop,
                    stop == 2'b00 ? "2 bits" : "unk   ",
                    parity_en,
                    baudrate,
                    delay
                );
        return s;
    endfunction : convert2string

endclass : uart_item

`endif // UART_ITEM__SV
