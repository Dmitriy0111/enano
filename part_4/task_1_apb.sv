import      uvm_pkg::*;
`include    "uvm_macros.svh"

class tr_1_apb extends uvm_object;

    rand    logic   [31 : 0]    PADDR;
    rand    logic   [31 : 0]    PRDATA;
    rand    logic   [31 : 0]    PWDATA;
    rand    logic   [0  : 0]    PWRITE;
    rand    logic   [0  : 0]    PSEL;
    rand    logic   [0  : 0]    PENABLE;

    `uvm_object_utils_begin(tr_1_apb)
        `uvm_field_int ( PADDR   , UVM_ALL_ON );
        `uvm_field_int ( PRDATA  , UVM_ALL_ON );
        `uvm_field_int ( PWDATA  , UVM_ALL_ON );
        `uvm_field_int ( PWRITE  , UVM_ALL_ON );
        `uvm_field_int ( PSEL    , UVM_ALL_ON );
        `uvm_field_int ( PENABLE , UVM_ALL_ON );
    `uvm_object_utils_end

    function new(string name = "tr_1_apb");
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

endclass : tr_1_apb

module task_1_apb;

    tr_1_apb        tr_1_apb_0 = new( "[ APB Transactor 0 ]" );
    tr_1_apb        tr_1_apb_1 = new( "[ APB Transactor 1 ]" );
    uvm_comparer    comparer;

    initial
    begin
        repeat(100)
        begin
            assert( tr_1_apb_0.randomize() ) else $stop;
            tr_1_apb_1.copy(tr_1_apb_0);
            repeat($urandom_range(0,5))
                case($urandom_range(0,1))
                    0       :   $display("Not changed data");
                    1       :   begin
                                    $display("Changed data");
                                    case($urandom_range(0,5))
                                        0       : tr_1_apb_1.PADDR   = $random();
                                        1       : tr_1_apb_1.PRDATA  = $random();
                                        2       : tr_1_apb_1.PWDATA  = $random();
                                        3       : tr_1_apb_1.PWRITE  = $random();
                                        4       : tr_1_apb_1.PSEL    = $random();
                                        5       : tr_1_apb_1.PENABLE = $random();
                                        default : ;
                                    endcase
                                end
                    default : ;
                endcase
            tr_1_apb_0.print();
            tr_1_apb_1.print();
            if( tr_1_apb_0.compare(tr_1_apb_1, comparer) )
                $display("Transactors is equal");
            else
                $display("Transactors is not equal");
        end
        $stop;
    end

endmodule : task_1_apb
