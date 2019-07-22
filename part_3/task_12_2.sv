class rand_1_2;

    typedef enum logic [2 : 0]  { BUSY = 3'b000 , READ = 3'b001 , WRITE = 3'b010 , ERROR = 3'b100 } mode_v;
    typedef enum logic [0 : 0]  { OK = '1 , UNDEF = '0 } status_v;

    rand    logic   [127 : 0]   data;
    rand    logic   [31  : 0]   addr;
    rand    logic   [15  : 0]   strob;
    rand    logic   [2   : 0]   mode;
    rand    logic   [0   : 0]   status;
    //  MODE = 000 -> BUSY 
    //  MODE = 001 -> READ 
    //  MODE = 010 -> WRITE 
    //  MODE = 100 -> ERROR 
    logic           [31 : 0]    max_user_addr = '1;

    integer                     dist_a[5] = {'0,'0,'0,'0,'0};

    constraint strob_c {
        strob == ('1 << addr[2 : 0]);
    }

    constraint addr_c {
        addr < max_user_addr;
        addr < '1;
        if( mode == READ ) {
            addr % 16 == 0;
        }
    }

    constraint status_c {
        if( mode == WRITE ) {
            status == OK;
        } else{
            status == UNDEF;
        }
    }

    constraint mode_c {
        mode inside { BUSY , READ , WRITE , ERROR };
    }

    constraint data_c {
        data dist   { 
                        [128'h0000_0000_0000_0000_0000_0000_0000_0001 : 128'h5555_5555_5555_5555_5555_5555_5555_5555] :/ 25 ,
                        [128'h5555_5555_5555_5555_5555_5555_5555_5556 : 128'hAAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAA9] :/ 25 , 
                        [128'hAAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAB : 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFE] :/ 25 , 
                        128'h5555_5555_5555_5555_5555_5555_5555_5555 :/ 10 , 
                        128'hAAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA :/ 10 ,
                        128'h0000_0000_0000_0000_0000_0000_0000_0000 :/ 1 ,
                        128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF :/ 1
                    };
    }

    function string make_rand(ref logic [127 : 0] data , ref logic [31  : 0] addr , ref logic [15 : 0] strob , ref logic [2 : 0] mode , ref logic [0 : 0] status);
        string ret_str;
        assert( this.randomize() ) else $stop;
        data = this.data;
        addr = this.addr;
        strob = this.strob;
        mode = this.mode;
        status = this.status;
        $sformat(ret_str," | 0x%h | 0x%h | 0b%b | 0b%b(%s) | 0b%b(%s) |", data, addr, strob, mode, mode == 3'b000 ? "BUSY " : mode == 3'b001 ? "READ " : mode == 3'b010 ? "WRITE" : mode == 3'b100 ? "ERROR" : "UNK  ", status, status ? "OK   " : "UNDEF" );
        return ret_str;
    endfunction : make_rand

    function new (logic [31 : 0] max_user_addr = '1);
        this.max_user_addr = max_user_addr;
    endfunction : new

    task set_max_user_addr(logic [31 : 0] max_user_addr);
        $display("New max addr = 0x%h", max_user_addr);
        this.max_user_addr = max_user_addr;
    endtask : set_max_user_addr

    task find_dist_data();
        if  ( 
                ( data != 128'h0000_0000_0000_0000_0000_0000_0000_0000 ) &&
                ( data != 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF ) &&
                ( data != 128'h5555_5555_5555_5555_5555_5555_5555_5555 ) &&
                ( data != 128'hAAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA )
            )
            dist_a[0]++;
        if( data == 128'h0000_0000_0000_0000_0000_0000_0000_0000 )
            dist_a[1]++;
        if( data == 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF )
            dist_a[2]++;
        if( data == 128'h5555_5555_5555_5555_5555_5555_5555_5555 )
            dist_a[3]++;
        if( data == 128'hAAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA )
            dist_a[4]++;
    endtask : find_dist_data

    task print_dist_data(integer rand_n);
        $display(" %d, %2.2f%% ", dist_a[0] , dist_a[0] * 100.0 / rand_n );
        $display(" %d, %2.2f%% ", dist_a[1] , dist_a[1] * 100.0 / rand_n );
        $display(" %d, %2.2f%% ", dist_a[2] , dist_a[2] * 100.0 / rand_n );
        $display(" %d, %2.2f%% ", dist_a[3] , dist_a[3] * 100.0 / rand_n );
        $display(" %d, %2.2f%% ", dist_a[4] , dist_a[4] * 100.0 / rand_n );
    endtask : print_dist_data

    task print_transaction();
        $display("| 0x%h | 0x%h | 0b%b | 0b%b(%s) | 0b%b(%s) |", data, addr, strob, mode, mode == 3'b000 ? "BUSY " : mode == 3'b001 ? "READ " : mode == 3'b010 ? "WRITE" : mode == 3'b100 ? "ERROR" : "UNK  ", status, status ? "OK   " : "UNDEF" );
    endtask : print_transaction

endclass : rand_1_2

class cover_2_2;

    typedef enum logic [2 : 0]  { BUSY = 3'b000 , READ = 3'b001 , WRITE = 3'b010 , ERROR = 3'b100 } mode_v;
    typedef enum logic [0 : 0]  { OK = '1 , UNDEF = '0 } status_v;

    logic   [127 : 0]   data = '0;
    logic   [31  : 0]   addr = '0;
    logic   [15  : 0]   strob = '0;
    logic   [2   : 0]   mode = '0;
    logic   [0   : 0]   status = '0;
    //  MODE = 000 -> BUSY 
    //  MODE = 001 -> READ 
    //  MODE = 010 -> WRITE 
    //  MODE = 100 -> ERROR 
    logic   [31 : 0]    max_user_addr = '1;

    covergroup rand_2_2_cg();

        mode_cp : coverpoint mode {
            bins            BUSY_b  = { BUSY  };
            bins            READ_b  = { READ  };
            bins            WRITE_b = { WRITE };
            bins            ERROR_b = { ERROR };
            illegal_bins    i_b     = { 3 , [5:7] };
        }

        mode_tr : coverpoint mode {
            // BUSY to others
            bins    BUSY2READ_b     = ( BUSY  => READ  );
            bins    BUSY2WRITE_b    = ( BUSY  => WRITE );
            bins    BUSY2ERROR_b    = ( BUSY  => ERROR );
            bins    BUSY2BUSY_b     = ( READ  => READ  );
            // READ to others
            bins    READ2BUSY_b     = ( READ  => BUSY  );
            bins    READ2WRITE_b    = ( READ  => WRITE );
            bins    READ2ERROR_b    = ( READ  => ERROR );
            bins    READ2READ_b     = ( READ  => READ  );
            // WRITE to others
            bins    WRITE2BUSY_b    = ( WRITE => BUSY  );
            bins    WRITE2READ_b    = ( WRITE => READ  );
            bins    WRITE2ERROR_b   = ( WRITE => ERROR );
            bins    WRITE2WRITE_b   = ( WRITE => WRITE );
            // ERROR to others
            bins    ERROR2BUSY_b    = ( ERROR => BUSY  );
            bins    ERROR2READ_b    = ( ERROR => READ  );
            bins    ERROR2WRITE_b   = ( ERROR => WRITE );
            bins    ERROR2ERROR_b   = ( ERROR => ERROR );
        }

        addr_cp : coverpoint addr {
            bins    tr00_00 = ( 0  =>  0 );
            bins    tr01_01 = ( 1  =>  1 );
            bins    tr02_02 = ( 2  =>  2 );
            bins    tr03_03 = ( 3  =>  3 );
            bins    tr04_04 = ( 4  =>  4 );
            bins    tr15_15 = ( 15 => 15 );
        }

        strob_cp : coverpoint strob {
            bins    strob_available[] = { 
                                            16'b1111111110000000, 
                                            16'b1111111111000000, 
                                            16'b1111111111100000, 
                                            16'b1111111111110000, 
                                            16'b1111111111111000, 
                                            16'b1111111111111100, 
                                            16'b1111111111111110, 
                                            16'b1111111111111111 
                                        };
        }

        data_cp : coverpoint data {
            bins    h5555_5555  =   {   128'h5555_5555_5555_5555_5555_5555_5555_5555 };
            bins    hAAAA_AAAA  =   {   128'hAAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA };
            bins    max         =   {   128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF };
            bins    min         =   {   128'h0000_0000_0000_0000_0000_0000_0000_0000 };
            bins    others      =   { 
                                        [128'h0000_0000_0000_0000_0000_0000_0000_0001 : 128'h5555_5555_5555_5555_5555_5555_5555_5555],
                                        [128'h5555_5555_5555_5555_5555_5555_5555_5556 : 128'hAAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAA9],
                                        [128'hAAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAB : 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFE] 
                                    };
        }

        addr_mode_cross : cross mode_tr, addr_cp {
            bins        WRITE2READ_0    = binsof(mode_tr.WRITE2READ_b) && binsof(addr_cp.tr00_00);
            bins        WRITE2READ_1    = binsof(mode_tr.WRITE2READ_b) && binsof(addr_cp.tr01_01);
            bins        WRITE2READ_2    = binsof(mode_tr.WRITE2READ_b) && binsof(addr_cp.tr02_02);
            bins        WRITE2READ_3    = binsof(mode_tr.WRITE2READ_b) && binsof(addr_cp.tr03_03);
            bins        WRITE2READ_4    = binsof(mode_tr.WRITE2READ_b) && binsof(addr_cp.tr04_04);
            bins        WRITE2READ_F    = binsof(mode_tr.WRITE2READ_b) && binsof(addr_cp.tr15_15);
            ignore_bins ib              = !binsof(mode_tr.WRITE2READ_b);
        }

        mode_tr_2 : coverpoint mode {
            bins    READ2READ_b = ( READ => BUSY , ERROR , WRITE => READ => BUSY , ERROR , WRITE );
        }
        
        mode_tr_3 : coverpoint mode {
            bins    MORE_READ2READ_b   = ( READ     [*3:7] );
            bins    MORE_WRITE2WRITE_b = ( WRITE    [*3:7] );
            bins    MORE_BUSY2BUSY_b   = ( BUSY     [*3:7] );
            bins    MORE_ERROR2ERROR_b = ( ERROR    [*3:7] );
        }

    endgroup : rand_2_2_cg

    function new (logic [31 : 0] max_user_addr = '1);
        this.max_user_addr = max_user_addr;
        rand_2_2_cg = new();
    endfunction : new

    task analyze( logic [127 : 0] data , logic [31  : 0] addr , logic [15 : 0] strob , logic [2 : 0] mode , logic [0 : 0] status );
        this.data = data;
        this.addr = addr;
        this.strob = strob;
        this.mode = mode;
        this.status = status;
        rand_2_2_cg.sample();
    endtask : analyze

endclass : cover_2_2

module task_12_2;

    parameter           repeat_n = 10000;

    string              rand_tr [] = new[repeat_n];

    integer             i = 0;

    logic   [127 : 0]   data;
    logic   [31  : 0]   addr;
    logic   [15  : 0]   strob;
    logic   [2   : 0]   mode;
    logic   [0   : 0]   status;

    rand_1_2            rand_1_2_  = new( 78 );
    cover_2_2           cover_2_2_ = new( 78 );

    initial
    begin
        rand_1_2_.set_max_user_addr( 78 );
        $display("|                DATA                |    ADDR    |       STROBE        |     MODE     |   STATUS   |");
        $display("| ---------------------------------- | ---------- | ------------------- | ------------ | ---------- |");
        for( i=0 ; i<repeat_n ; i++ )
        begin
            rand_tr[i] = rand_1_2_.make_rand( data , addr , strob , mode , status );
            rand_1_2_.find_dist_data();
            rand_1_2_.print_transaction();
            cover_2_2_.analyze( data , addr , strob , mode , status );
        end
        rand_1_2_.print_dist_data(repeat_n);
        $stop;
    end

endmodule : task_12_2
