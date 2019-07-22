import uvm_pkg::*;
`include    "uvm_macros.svh"

class tr_1_apb extends uvm_object;

    typedef enum { APB_READ , APB_WRITE } APB_RW;

    rand    logic   [31 : 0]    PADDR;
    rand    logic   [31 : 0]    PWDATA;
    rand    APB_RW              APB_RW_;

    `uvm_object_utils_begin(tr_1_apb)
        `uvm_field_int  ( PADDR   , UVM_DEFAULT );
        `uvm_field_int  ( PWDATA  , UVM_DEFAULT );
        `uvm_field_enum ( APB_RW , APB_RW_ , UVM_DEFAULT );
    `uvm_object_utils_end

    function new(string name = "tr_1_apb");
        super.new(name);
    endfunction : new

    function void set_default();
        PADDR = '0;
        PWDATA = '0;
        APB_RW_ = APB_READ;
    endfunction : set_default

endclass : tr_1_apb

module task_1_apb;

    tr_1_apb    tr_1_apb_  = new( "[ APB Transactor ]" );

    initial
    begin
        $stop;
    end

endmodule : task_1_apb
