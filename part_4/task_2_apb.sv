import uvm_pkg::*;
`include    "uvm_macros.svh"

class tr_2_apb extends uvm_object;

    typedef enum { APB_READ , APB_WRITE } APB_RW;

    rand    logic   [31 : 0]    PADDR;
    rand    logic   [31 : 0]    PWDATA;
    rand    logic   [0  : 0]    PWRITE;

    function new(string name = "tr_2_apb");
        super.new(name);
    endfunction : new

    function void set_default();
        PADDR = '0;
        PWDATA = '0;
        PWRITE = '0;
    endfunction : set_default

    function void do_print(uvm_printer printer);
        super.do_print(printer);
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
        this.PADDR = tr_2_apb_.PADDR;
        this.PWDATA = tr_2_apb_.PWDATA;
        this.PWRITE = tr_2_apb_.PWRITE;
    endfunction : do_copy

    function string convert2string();
        string s;
        $sformat( s , "%s\n"                , super.convert2string()            );
        $sformat( s , "%s\n PADDR   %h"     , s , PADDR                         );
        $sformat( s , "%s\n PWDATA  %h"     , s , PWDATA                        );
        $sformat( s , "%s\n PWRITE  %h(%s)" , s , PWRITE , PWRITE ? "WR" : "RD" );
        $sformat( s , "%s\n"                , s                                 );
        return s;
    endfunction : convert2string

    function void do_record(uvm_recorder recorder);
        super.do_record(recorder);
        `uvm_record_field( "PADDR"  , PADDR  )
        `uvm_record_field( "PWDATA" , PWDATA )
        `uvm_record_field( "PWRITE" , PWRITE )
    endfunction : do_record

    function bit do_compare(uvm_object rhs, uvm_comparer comparer = null);
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
        if( this.PADDR  != tr_2_apb_.PADDR  ) return '0;
        if( this.PWDATA != tr_2_apb_.PWDATA ) return '0;
        if( this.PWRITE != tr_2_apb_.PWRITE ) return '0;
        return '1;
    endfunction : do_compare

endclass : tr_2_apb

module task_2_apb;

    tr_2_apb    tr_2_apb_  = new( "[ APB Transactor ]" );
    tr_2_apb    tr_2_apb__  = new( "[ APB Transactor ]" );
    uvm_recorder recorder;

    initial
    begin
        repeat(100)
        begin
            assert( tr_2_apb_.randomize() ) else $stop;
            tr_2_apb__ = tr_2_apb_.do_clone();
            $display("%s",tr_2_apb_.convert2string());
            tr_2_apb_.do_record(recorder);
            if( tr_2_apb_.do_compare(tr_2_apb__) )
                $display("Transactors is equal");
            else
                $display("Transactors is not equal");
        end
        $stop;
    end

endmodule : task_2_apb
