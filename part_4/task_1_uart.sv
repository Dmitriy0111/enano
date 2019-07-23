import      uvm_pkg::*;
`include    "uvm_macros.svh"

class tr_1_uart extends uvm_object;

    rand    logic   [7  : 0]    tx_data;
    rand    logic   [1  : 0]    stop;
    rand    logic   [0  : 0]    parity;
    rand    logic   [15 : 0]    baudrate;
    rand    integer             delay;

    `uvm_object_utils_begin(tr_1_uart)
        `uvm_field_int ( tx_data  , UVM_ALL_ON );
        `uvm_field_int ( stop     , UVM_ALL_ON );
        `uvm_field_int ( parity   , UVM_ALL_ON );
        `uvm_field_int ( baudrate , UVM_ALL_ON );
        `uvm_field_int ( delay    , UVM_ALL_ON );
    `uvm_object_utils_end

    function new(string name = "tr_1_uart");
        super.new(name);
    endfunction : new

    function void set_default();
        tx_data  = '0;
        stop     = '0;
        parity   = '0;
        baudrate = '0;
        delay    = '0;
    endfunction : set_default

endclass : tr_1_uart

module task_1_uart;

    tr_1_uart       tr_1_uart_0 = new( "[ UART Transactor 0 ]" );
    tr_1_uart       tr_1_uart_1 = new( "[ UART Transactor 1 ]" );
    uvm_comparer    comparer;

    initial
    begin
        repeat(100)
        begin
            assert( tr_1_uart_0.randomize() ) else $stop;
            tr_1_uart_1.copy(tr_1_uart_0);
            repeat($urandom_range(0,4))
                case($urandom_range(0,1))
                    0       :   $display("Not changed data");
                    1       :   begin
                                    $display("Changed data");
                                    case($urandom_range(0,4))
                                        0       : tr_1_uart_1.tx_data  = $random();
                                        1       : tr_1_uart_1.stop     = $random();
                                        2       : tr_1_uart_1.parity   = $random();
                                        3       : tr_1_uart_1.baudrate = $random();
                                        4       : tr_1_uart_1.delay    = $random();
                                        default : ;
                                    endcase
                                end
                    default : ;
                endcase
            tr_1_uart_0.print();
            tr_1_uart_1.print();
            if( tr_1_uart_0.compare(tr_1_uart_1) )
                $display("Transactors is equal");
            else
                $display("Transactors is not equal");
        end
        $stop;
    end

endmodule : task_1_uart
