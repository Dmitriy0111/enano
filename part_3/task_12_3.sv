class rand_1_3;

    typedef struct packed{
        logic   [63 : 0]    data_0;
        logic   [63 : 0]    data_1;
        integer             freq;
    } data_i;

    typedef enum logic [2 : 0]  { BUSY = 3'b000 , READ = 3'b001 , WRITE = 3'b010 , ERROR = 3'b100 } mode_v;
    typedef enum logic [0 : 0]  { OK = '1 , UNDEF = '0 } status_v;

    rand    logic   [63 : 0]    data;
    rand    logic   [31 : 0]    addr;
    rand    logic   [7  : 0]    strob;
    rand    logic   [2  : 0]    mode;
    rand    logic   [0  : 0]    status;
    rand    logic   [0  : 0]    delay_en;
    rand    integer             write_delay;
    rand    integer             read_delay;    

    rand    logic   [0  : 0]    strob_dir;
    rand    logic   [2  : 0]    strob_shift;        
    //  MODE = 000 -> BUSY 
    //  MODE = 001 -> READ 
    //  MODE = 010 -> WRITE 
    //  MODE = 100 -> ERROR 

    data_i                      data_i_ [$] =
                                                '{
                                                    '{ 64'h0000_0000_0000_0001 , 64'h5555_5555_5555_5554 , 29 },
                                                    '{ 64'h5555_5555_5555_5556 , 64'hAAAA_AAAA_AAAA_AAA9 , 29 }, 
                                                    '{ 64'hAAAA_AAAA_AAAA_AAAB , 64'hFFFF_FFFF_FFFF_FFFE , 29 }, 
                                                    '{ 64'h5555_5555_5555_5555 , 64'h5555_5555_5555_5555 ,  5 }, 
                                                    '{ 64'hAAAA_AAAA_AAAA_AAAA , 64'hAAAA_AAAA_AAAA_AAAA ,  5 }, 
                                                    '{ 64'h0000_0000_0000_0000 , 64'h0000_0000_0000_0000 ,  1 }, 
                                                    '{ 64'hFFFF_FFFF_FFFF_FFFF , 64'hFFFF_FFFF_FFFF_FFFF ,  1 } 
                                                };

    integer                     freq_sum = 0;
    integer                     rand_i = 0;
    integer                     dist_a[7] = {'0,'0,'0,'0,'0,'0,'0};

    constraint strob_c {
        if( strob_dir ) {
            strob == '1 << strob_shift;
        } else {
            strob == '1 >> strob_shift;
        }
    }

    constraint mode_c {
        mode inside { BUSY , READ , WRITE , ERROR };
    }

    constraint addr_cp {
        addr <= 32'h0000_000F; //32'hFFFF_FFFF;
        addr >= 32'h0000_0000;
    }

    constraint data_c {
        data inside { [ data_i_[rand_i].data_0 : data_i_[rand_i].data_1 ] };
    }

    constraint write_delay_c {
        if( delay_en ) {
            write_delay < 10;
            write_delay >= 0;
        } else {
            write_delay == 0;
        }
    }

    constraint read_delay_c {
        if( delay_en ) {
            read_delay < 200;
            read_delay >= 0;
        } else {
            read_delay == 0;
        }
    }

    function string make_rand(ref logic [63 : 0] data , ref logic [31  : 0] addr , ref logic [7 : 0] strob , ref logic [2 : 0] mode , ref logic [0 : 0] status);
        string ret_str;
        assert( this.randomize() ) else $stop;
        data = this.data;
        addr = this.addr;
        strob = this.strob;
        mode = this.mode;
        status = this.status;
        $sformat(
                    ret_str,
                    "| 0x%h | 0x%h | 0b%b | 0b%b(%s) | 0b%b(%s) |    0b%b   |  0x%h | 0x%h |",   
                    data, 
                    addr, 
                    strob, 
                    mode, 
                    mode == 3'b000 ? "BUSY " : mode == 3'b001 ? "READ " : mode == 3'b010 ? "WRITE" : mode == 3'b100 ? "ERROR" : "UNK  ", 
                    status, 
                    status ? "OK   " : "UNDEF", 
                    delay_en, 
                    write_delay, 
                    read_delay 
                );
        return ret_str;
    endfunction : make_rand

    function void pre_randomize();
        rand_i = find_data_i();
        $display("rand_i = %d", rand_i);
    endfunction : pre_randomize

    function integer find_data_i();
        integer rand_v;
        rand_v = $urandom_range(freq_sum-1);
        for( integer i = 0 ; i < data_i_.size() ; i++ )
        begin
            if(rand_v < data_i_[i].freq )
                return i;
            rand_v -= data_i_[i].freq;
        end
        return 0;
    endfunction : find_data_i

    function new();
        freq_sum = 0;
        foreach(data_i_[i])
            freq_sum += data_i_[i].freq;
    endfunction : new

    task find_dist_data();
        foreach( dist_a[i] )
            if( ( data >= data_i_[i].data_0 ) && ( data <= data_i_[i].data_1 ) )
                dist_a[i]++;
    endtask : find_dist_data

    task print_dist_data(integer rand_n);
        foreach( dist_a[i] )
            $display(" data in range [0x%h : 0x%h] %d, %2.2f%% ", data_i_[i].data_0 , data_i_[i].data_1 , dist_a[i] , dist_a[i] * 100.0 / rand_n );
    endtask : print_dist_data

    task print_transaction();
        $display(   "| 0x%h | 0x%h | 0b%b | 0b%b(%s) | 0b%b(%s) |    0b%b   |  0x%h | 0x%h |",   
                    data, 
                    addr, 
                    strob, 
                    mode, 
                    mode == 3'b000 ? "BUSY " : mode == 3'b001 ? "READ " : mode == 3'b010 ? "WRITE" : mode == 3'b100 ? "ERROR" : "UNK  ", 
                    status, 
                    status ? "OK   " : "UNDEF", 
                    delay_en, 
                    write_delay, 
                    read_delay 
                );
    endtask : print_transaction

endclass : rand_1_3

class cover_2_3;

    typedef enum logic [2 : 0]  { BUSY = 3'b000 , READ = 3'b001 , WRITE = 3'b010 , ERROR = 3'b100 } mode_v;
    typedef enum logic [0 : 0]  { OK = '1 , UNDEF = '0 } status_v;

    logic   [63 : 0]    data = '0;
    logic   [31 : 0]    addr = '0;
    logic   [7  : 0]    strob = '0;
    logic   [2  : 0]    mode = '0;
    logic   [0  : 0]    status = '0;
    //  MODE = 000 -> BUSY 
    //  MODE = 001 -> READ 
    //  MODE = 010 -> WRITE 
    //  MODE = 100 -> ERROR 

    covergroup rand_2_3_cg();

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
            bins            strob_available[] = { 
                                                    8'h01, 
                                                    8'h03, 
                                                    8'h07, 
                                                    8'h0F,
                                                    8'h1F, 
                                                    8'h3F, 
                                                    8'h7F, 
                                                    8'hFF, 
                                                    8'hFE, 
                                                    8'hFC, 
                                                    8'hF8, 
                                                    8'hF0,
                                                    8'hE0, 
                                                    8'hC0, 
                                                    8'h80 
                                                };
            illegal_bins    i_b =   default;
        }

        data_cp : coverpoint data {
            bins    h5555_5555  =   {   64'h5555_5555_5555_5555 };
            bins    hAAAA_AAAA  =   {   64'hAAAA_AAAA_AAAA_AAAA };
            bins    max         =   {   64'hFFFF_FFFF_FFFF_FFFF };
            bins    min         =   {   64'h0000_0000_0000_0000 };
            bins    others      =   { 
                                        [64'h0000_0000_0000_0001 : 64'h5555_5555_5555_5555],
                                        [64'h5555_5555_5555_5556 : 64'hAAAA_AAAA_AAAA_AAA9],
                                        [64'hAAAA_AAAA_AAAA_AAAB : 64'hFFFF_FFFF_FFFF_FFFE] 
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

    endgroup : rand_2_3_cg

    function new ();
        rand_2_3_cg = new();
    endfunction : new

    task analyze( logic [63 : 0] data , logic [31  : 0] addr , logic [7 : 0] strob , logic [2 : 0] mode , logic [0 : 0] status );
        this.data = data;
        this.addr = addr;
        this.strob = strob;
        this.mode = mode;
        this.status = status;
        rand_2_3_cg.sample();
    endtask : analyze

endclass : cover_2_3

module task_12_3;

    parameter           repeat_n = 10000;

    string              rand_tr [] = new[repeat_n];

    integer             i = 0;

    logic   [63  : 0]   data;
    logic   [31  : 0]   addr;
    logic   [7   : 0]   strob;
    logic   [2   : 0]   mode;
    logic   [0   : 0]   status;

    rand_1_3            rand_1_3_  = new();
    cover_2_3           cover_2_3_ = new();

    initial
    begin
        $display("|        DATA        |    ADDR    |   STROBE   |     MODE     |   STATUS   | DELAY_EN | WRITE_DELAY | READ_DELAY |");
        $display("| ------------------ | ---------- | ---------- | ------------ | ---------- | -------- | ----------- | ---------- |");
        for( i=0 ; i<repeat_n ; i++ )
        begin
            rand_tr[i] = rand_1_3_.make_rand( data , addr , strob , mode , status );
            rand_1_3_.find_dist_data();
            rand_1_3_.print_transaction();
            cover_2_3_.analyze( data , addr , strob , mode , status );
        end
        rand_1_3_.print_dist_data(repeat_n);
        $stop;
    end

endmodule : task_12_3
