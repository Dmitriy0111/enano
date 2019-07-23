import      uvm_pkg::*;
`include    "uvm_macros.svh"

class tr_2_apb extends uvm_object;
    `uvm_object_utils(tr_2_apb)

    rand    logic   [31 : 0]    PADDR;
    rand    logic   [31 : 0]    PRDATA;
    rand    logic   [31 : 0]    PWDATA;
    rand    logic   [0  : 0]    PWRITE;
    rand    logic   [0  : 0]    PSEL;
    rand    logic   [0  : 0]    PENABLE;

    function new(string name = "tr_2_apb");
        super.new(name);
    endfunction : new

    function void set_default();
        PADDR = '0;
        PRDATA = '0;
        PWDATA = '0;
        PWRITE = '0;
        PSEL = '0;
        PENABLE = '0;
    endfunction : set_default

    function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_int( "PADDR"   , PADDR   , $bits( PADDR   ) );
        printer.print_int( "PRDATA"  , PRDATA  , $bits( PRDATA  ) );
        printer.print_int( "PWDATA"  , PWDATA  , $bits( PWDATA  ) );
        printer.print_int( "PWRITE"  , PWRITE  , $bits( PWRITE  ) );
        printer.print_int( "PSEL"    , PSEL    , $bits( PSEL    ) );
        printer.print_int( "PENABLE" , PENABLE , $bits( PENABLE ) );
    endfunction : do_print

    function uvm_object do_clone();
        tr_2_apb tr_2_apb_;
        tr_2_apb_ = new();
        tr_2_apb_.do_copy(this);
        return tr_2_apb_;
    endfunction : do_clone

    function void do_copy(uvm_object rhs = null);
        tr_2_apb tr_2_apb_;
        super.do_copy(rhs);
        if(!$cast(tr_2_apb_,rhs))
            `uvm_fatal("DO_COPY", "Cannot cast of rhs object")
        this.PADDR   = tr_2_apb_.PADDR;
        this.PWDATA  = tr_2_apb_.PWDATA;
        this.PRDATA  = tr_2_apb_.PRDATA;
        this.PWRITE  = tr_2_apb_.PWRITE;
        this.PSEL    = tr_2_apb_.PSEL;
        this.PENABLE = tr_2_apb_.PENABLE;
    endfunction : do_copy

    function string convert2string();
        string s;
        $sformat( s , "%s\n"                , super.convert2string()            );
        $sformat( s , "%s\n PADDR   %h"     , s , PADDR                         );
        $sformat( s , "%s\n PRDATA  %h"     , s , PRDATA                        );
        $sformat( s , "%s\n PWDATA  %h"     , s , PWDATA                        );
        $sformat( s , "%s\n PWRITE  %h(%s)" , s , PWRITE , PWRITE ? "WR" : "RD" );
        $sformat( s , "%s\n PSEL  %h"       , s , PSEL                          );
        $sformat( s , "%s\n PENABLE  %h"    , s , PENABLE                       );
        $sformat( s , "%s\n"                , s                                 );
        return s;
    endfunction : convert2string

    function void do_record(uvm_recorder recorder);
        super.do_record(recorder);
        `uvm_record_field( "PADDR"   , PADDR   )
        `uvm_record_field( "PWDATA"  , PWDATA  )
        `uvm_record_field( "PRDATA"  , PRDATA  )
        `uvm_record_field( "PWRITE"  , PWRITE  )
        `uvm_record_field( "PSEL"    , PSEL    )
        `uvm_record_field( "PENABLE" , PENABLE )
    endfunction : do_record

    function bit do_compare(uvm_object rhs, uvm_comparer comparer = null);
        integer i;
        tr_2_apb tr_2_apb_;
        do_compare = super.do_compare(rhs,comparer);
        if(rhs == null)
        begin
            `uvm_fatal("COMPARE","Cannot compare to null instance")
            return '0;
        end
        if(!$cast(tr_2_apb_,rhs))
        begin
            `uvm_fatal("COMPARE","Attempting to compare to a non tr_2_apb instance")
            return '0;
        end
        i = 0;
        if( this.PADDR   != tr_2_apb_.PADDR   ) begin $display("PADDR   is not equal, %h != %h" , this.PADDR   , tr_2_apb_.PADDR   ); i++; end
        if( this.PRDATA  != tr_2_apb_.PRDATA  ) begin $display("PRDATA  is not equal, %h != %h" , this.PRDATA  , tr_2_apb_.PRDATA  ); i++; end
        if( this.PWDATA  != tr_2_apb_.PWDATA  ) begin $display("PWDATA  is not equal, %h != %h" , this.PWDATA  , tr_2_apb_.PWDATA  ); i++; end
        if( this.PWRITE  != tr_2_apb_.PWRITE  ) begin $display("PWRITE  is not equal, %h != %h" , this.PWRITE  , tr_2_apb_.PWRITE  ); i++; end
        if( this.PSEL    != tr_2_apb_.PSEL    ) begin $display("PSEL    is not equal, %h != %h" , this.PSEL    , tr_2_apb_.PSEL    ); i++; end
        if( this.PENABLE != tr_2_apb_.PENABLE ) begin $display("PENABLE is not equal, %h != %h" , this.PENABLE , tr_2_apb_.PENABLE ); i++; end
        if( i != '0 )
            return '0;
        else
            return '1;
    endfunction : do_compare

endclass : tr_2_apb

module task_2_apb;

    tr_2_apb    tr_2_apb_0 = new( "[ APB Transactor 0 ]" );
    tr_2_apb    tr_2_apb_1 = new( "[ APB Transactor 1 ]" );

    initial
    begin
        repeat(100)
        begin
            assert( tr_2_apb_0.randomize() ) else $stop;
            tr_2_apb_1.copy(tr_2_apb_0);
            repeat($urandom_range(0,5))
                case($urandom_range(0,1))
                    0       :   $display("Not changed data");
                    1       :   begin
                                    $display("Changed data");
                                    case($urandom_range(0,5))
                                        0       : tr_2_apb_1.PADDR   = $random();
                                        1       : tr_2_apb_1.PRDATA  = $random();
                                        2       : tr_2_apb_1.PWDATA  = $random();
                                        3       : tr_2_apb_1.PWRITE  = $random();
                                        4       : tr_2_apb_1.PSEL    = $random();
                                        5       : tr_2_apb_1.PENABLE = $random();
                                        default : ;
                                    endcase
                                end
                    default : ;
                endcase
            tr_2_apb_0.print();
            tr_2_apb_1.print();
            if( tr_2_apb_0.compare(tr_2_apb_1) )
                $display("Transactors is equal");
            else
                $display("Transactors is not equal");
        end
        $stop;
    end

endmodule : task_2_apb
