import      uvm_pkg::*;
`include    "uvm_macros.svh"

class tr_2_uart extends uvm_object;
    `uvm_object_utils(tr_2_uart)

    rand    logic   [7  : 0]    tx_data;
    rand    logic   [1  : 0]    stop;
    rand    logic   [0  : 0]    parity;
    rand    logic   [15 : 0]    baudrate;
    rand    integer             delay;

    function new(string name = "tr_2_uart");
        super.new(name);
    endfunction : new

    function void set_default();
        tx_data  = '0;
        stop     = '0;
        parity   = '0;
        baudrate = '0;
        delay    = '0;
    endfunction : set_default

    function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_int( "tx_data"  , tx_data  , $bits( tx_data  ) );
        printer.print_int( "stop"     , stop     , $bits( stop     ) );
        printer.print_int( "parity"   , parity   , $bits( parity   ) );
        printer.print_int( "baudrate" , baudrate , $bits( baudrate ) );
        printer.print_int( "delay"    , delay    , $bits( delay    ) );
    endfunction : do_print

    function uvm_object do_clone();
        tr_2_uart tr_2_uart_;
        tr_2_uart_ = new();
        tr_2_uart_.do_copy(this);
        return tr_2_uart_;
    endfunction : do_clone

    function void do_copy(uvm_object rhs = null);
        tr_2_uart tr_2_uart_;
        super.do_copy(rhs);
        if(!$cast(tr_2_uart_,rhs))
            `uvm_fatal("DO_COPY", "Cannot cast of rhs object")
        this.tx_data  = tr_2_uart_.tx_data;
        this.stop     = tr_2_uart_.stop;
        this.parity   = tr_2_uart_.parity;
        this.baudrate = tr_2_uart_.baudrate;
        this.delay    = tr_2_uart_.delay;
    endfunction : do_copy

    function string convert2string();
        string s;
        $sformat( s , "%s\n"              , super.convert2string() );
        $sformat( s , "%s\n tx_data   %h" , s , tx_data            );
        $sformat( s , "%s\n stop  %h"     , s , stop               );
        $sformat( s , "%s\n parity  %h"   , s , parity             );
        $sformat( s , "%s\n baudrate  %h" , s , baudrate           );
        $sformat( s , "%s\n delay  %h"    , s , delay              );
        $sformat( s , "%s\n"              , s                      );
        return s;
    endfunction : convert2string

    function void do_record(uvm_recorder recorder);
        super.do_record(recorder);
        `uvm_record_field( "PADDR"   , tx_data   )
        `uvm_record_field( "PWDATA"  , stop      )
        `uvm_record_field( "PRDATA"  , parity    )
        `uvm_record_field( "PWRITE"  , baudrate  )
        `uvm_record_field( "PSEL"    , delay     )
    endfunction : do_record

    function bit do_compare(uvm_object rhs, uvm_comparer comparer = null);
        integer i;
        tr_2_uart tr_2_uart_;
        do_compare = super.do_compare(rhs,comparer);
        if(rhs == null)
        begin
            `uvm_fatal("COMPARE","Cannot compare to null instance")
            return '0;
        end
        if(!$cast(tr_2_uart_,rhs))
        begin
            `uvm_fatal("COMPARE","Attempting to compare to a non tr_2_uart instance")
            return '0;
        end
        i = 0;
        if( this.tx_data  != tr_2_uart_.tx_data  ) begin $display("tx_data   is not equal, %h != %h" , this.tx_data  , tr_2_uart_.tx_data  ); i++; end
        if( this.stop     != tr_2_uart_.stop     ) begin $display("stop      is not equal, %h != %h" , this.stop     , tr_2_uart_.stop     ); i++; end
        if( this.parity   != tr_2_uart_.parity   ) begin $display("parity    is not equal, %h != %h" , this.parity   , tr_2_uart_.parity   ); i++; end
        if( this.baudrate != tr_2_uart_.baudrate ) begin $display("baudrate  is not equal, %h != %h" , this.baudrate , tr_2_uart_.baudrate ); i++; end
        if( this.delay    != tr_2_uart_.delay    ) begin $display("delay     is not equal, %h != %h" , this.delay    , tr_2_uart_.delay    ); i++; end
        if( i != '0 )
            return '0;
        else
            return '1;
    endfunction : do_compare

endclass : tr_2_uart

module task_2_uart;

    tr_2_uart    tr_2_uart_0 = new( "[ UART Transactor 0 ]" );
    tr_2_uart    tr_2_uart_1 = new( "[ UART Transactor 1 ]" );

    initial
    begin
        repeat(100)
        begin
            assert( tr_2_uart_0.randomize() ) else $stop;
            tr_2_uart_1.copy(tr_2_uart_0);
            repeat($urandom_range(0,4))
                case($urandom_range(0,1))
                    0       :   $display("Not changed data");
                    1       :   begin
                                    $display("Changed data");
                                    case($urandom_range(0,4))
                                        0       : tr_2_uart_1.tx_data  = $random();
                                        1       : tr_2_uart_1.stop     = $random();
                                        2       : tr_2_uart_1.parity   = $random();
                                        3       : tr_2_uart_1.baudrate = $random();
                                        4       : tr_2_uart_1.delay    = $random();
                                        default : ;
                                    endcase
                                end
                    default : ;
                endcase
            tr_2_uart_0.print();
            tr_2_uart_1.print();
            if( tr_2_uart_0.compare(tr_2_uart_1) )
                $display("Transactors is equal");
            else
                $display("Transactors is not equal");
        end
        $stop;
    end

endmodule : task_2_uart
