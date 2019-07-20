class rand_1_2;

    typedef enum logic [2 : 0]  { BUSY = 3'b000 , READ = 3'b001 , WRITE = 3'b010 , ERROR = 3'b100 } mode_v;
    typedef enum logic [0 : 0]  { OK = '1 , UNDEF = '0 } status_v;

    rand    logic   [127 : 0]   data;
    rand    logic   [31  : 0]   addr;
    rand    logic   [16  : 0]   strob;
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
        if( mode == READ ) {   // READ
            addr % 8 == 0;
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

    function string make_rand();
        string ret_str;
        this.randomize();
        $sformat(ret_str," | 0x%h | 0x%h | 0b%b | 0x%b(%s) | 0b%b(%s)", data, addr, strob, mode, mode == 3'b000 ? "BUSY " : mode == 3'b001 ? "READ " : mode == 3'b010 ? "WRITE" : mode == 3'b100 ? "ERROR" : "UNK  ", status, status ? "OK   " : "UNDEF" );
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
        $display("| 0x%h | 0x%h | 0b%b | 0x%b(%s) | 0b%b(%s) |", data, addr, strob, mode, mode == 3'b000 ? "BUSY " : mode == 3'b001 ? "READ " : mode == 3'b010 ? "WRITE" : mode == 3'b100 ? "ERROR" : "UNK  ", status, status ? "OK   " : "UNDEF" );
    endtask : print_transaction

endclass : rand_1_2

module task_12_2;

    parameter   repeat_n = 1000;

    string      rand_tr [] = new[repeat_n];

    integer     i = 0;

    rand_1_2    rand_1_2_  = new( 32'h1000 );

    initial
    begin
        rand_tr[0] = "Hello";
        rand_1_2_.set_max_user_addr(32'h1_0000);
        $display("|                DATA                |    ADDR    |       STROBE        |     MODE     |   STATUS   |");
        $display("| ---------------------------------- | ---------- | ------------------- | ------------ | ---------- |");
        for( i=0 ; i<repeat_n ; i++ )
        begin
            rand_tr[i] = rand_1_2_.make_rand();
            rand_1_2_.find_dist_data();
            rand_1_2_.print_transaction();
        end
        rand_1_2_.print_dist_data(repeat_n);
        $stop;
    end

endmodule : task_12_2
