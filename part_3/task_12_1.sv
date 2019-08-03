class rand_1_1;

    typedef struct packed{
        logic   [31 : 0]    data_0;
        logic   [31 : 0]    data_1;
        integer             freq;
    } data_i;

    typedef enum logic [2 : 0]  { BUSY = 3'b000 , READ = 3'b001 , WRITE = 3'b010 , ERROR = 3'b100 } mode_v;

    rand    logic   [31 : 0]    data;
    rand    logic   [31 : 0]    addr;
    rand    logic   [3  : 0]    strob;
    rand    logic   [2  : 0]    mode;
    //  MODE = 000 -> BUSY 
    //  MODE = 001 -> READ 
    //  MODE = 010 -> WRITE 
    //  MODE = 100 -> ERROR 
    logic           [31 : 0]    max_addr = '1;
    logic           [31 : 0]    min_addr = '0;

    data_i                      data_i_ [$] =
                                                '{
                                                    '{ 32'h0000_0000 , 32'h5555_5554 , 26 },
                                                    '{ 32'h5555_5556 , 32'hAAAA_AAA9 , 26 }, 
                                                    '{ 32'hAAAA_AAAB , 32'hFFFF_FFFF , 26 }, 
                                                    '{ 32'h5555_5555 , 32'h5555_5555 , 10 }, 
                                                    '{ 32'hAAAA_AAAA , 32'hAAAA_AAAA , 10 } 
                                                };

    integer                     freq_sum = 0;
    integer                     rand_i = 0;

    integer                     dist_a[5] = {'0,'0,'0,'0,'0};

    constraint strob_c {
        strob inside { 4'b0001, 4'b0011, 4'b0111, 4'b1111, 4'b1110, 4'b1100, 4'b1000 };
    }

    constraint addr_c {
        addr < max_addr;
        addr > min_addr;
        if( mode == READ ) {
            addr % 2 == 0;
        }
        if( mode == WRITE ) {
            addr % 4 == 0;
        }
    }

    constraint mode_c {
        mode inside { BUSY , READ , WRITE , ERROR };
    }

    constraint data_c {
        data inside { [ data_i_[rand_i].data_0 : data_i_[rand_i].data_1 ] };
    }

    function void pre_randomize();
        rand_i = find_data_i();
        $display("rand_i = %d", rand_i);
    endfunction : pre_randomize

    function string make_rand();
        string ret_str;
        assert( this.randomize() ) else $stop;
        $sformat(ret_str,"| 0x%h | 0x%h | 0b%b | 0x%b(%s) |", data, addr, strob, mode, mode == 3'b000 ? "BUSY " : mode == 3'b001 ? "READ " : mode == 3'b010 ? "WRITE" : mode == 3'b100 ? "ERROR" : "UNK  " );
        return ret_str;
    endfunction : make_rand

    function new(logic [31 : 0] min_addr = '0, logic [31 : 0] max_addr = '1);
        this.min_addr = min_addr;
        this.max_addr = max_addr;
        freq_sum = 0;
        foreach(data_i_[i])
            freq_sum += data_i_[i].freq;
    endfunction : new

    task set_max_addr(logic [31 : 0] max_addr);
        $display("New max addr = 0x%h", max_addr);
        this.max_addr = max_addr;
    endtask : set_max_addr

    task set_min_addr(logic [31 : 0] min_addr);
        $display("New min addr = 0x%h", min_addr);
        this.min_addr = min_addr;
    endtask : set_min_addr

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
        $display("| 0x%h | 0x%h | 0b%b | 0x%b(%s) |", data, addr, strob, mode, mode == 3'b000 ? "BUSY " : mode == 3'b001 ? "READ " : mode == 3'b010 ? "WRITE" : mode == 3'b100 ? "ERROR" : "UNK  " );
    endtask : print_transaction

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

endclass : rand_1_1

class cover_2_1;

    typedef enum logic [2 : 0]  { BUSY = 3'b000 , READ = 3'b001 , WRITE = 3'b010 , ERROR = 3'b100 } mode_v;

    logic   [31 : 0]    data = '0;
    logic   [31 : 0]    addr = '0;
    logic   [3  : 0]    strob = '0;
    logic   [2  : 0]    mode = '0;

    logic   [31 : 0]    min_addr;
    logic   [31 : 0]    max_addr;

    covergroup rand_2_1_cg();

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

        strob_cp : coverpoint strob {
            bins    strob_available[] = { 4'b0001, 4'b0011, 4'b0111, 4'b1111, 4'b1110, 4'b1100, 4'b1000 };
        }

        data_cp : coverpoint data {
            bins    h5555_5555  = { 32'h5555_5555 };
            bins    hAAAA_AAAA  = { 32'hAAAA_AAAA };
            bins    others      = { [32'h0000_0000 : 32'h5555_5554] , [32'h5555_5556 : 32'hAAAA_AAA9] , [32'hAAAA_AAAB : 32'hFFFF_FFFF] };
        }

        addr_cp : coverpoint addr {
            bins    addr_b  [16] = { [min_addr : max_addr] };
        }

        h5555_5555_cross : cross mode_cp, data_cp {
            bins            BUSY_b  = binsof(mode_cp.BUSY_b)  && binsof( data_cp ) intersect { 32'h5555_5555 };
            bins            READ_b  = binsof(mode_cp.READ_b)  && binsof( data_cp ) intersect { 32'h5555_5555 };
            bins            WRITE_b = binsof(mode_cp.WRITE_b) && binsof( data_cp ) intersect { 32'h5555_5555 };
            bins            ERROR_b = binsof(mode_cp.ERROR_b) && binsof( data_cp ) intersect { 32'h5555_5555 };
            ignore_bins     i_b     = binsof(data_cp) intersect { 32'hAAAA_AAAA , [32'h0000_0000 : 32'h5555_5554] , [32'h5555_5556 : 32'hAAAA_AAA9] , [32'hAAAA_AAAB : 32'hFFFF_FFFF] };
        }

        hAAAA_AAAA_cross : cross mode_cp, data_cp {
            bins            BUSY_b  = binsof(mode_cp.BUSY_b)  && binsof( data_cp ) intersect { 32'hAAAA_AAAA };
            bins            READ_b  = binsof(mode_cp.READ_b)  && binsof( data_cp ) intersect { 32'hAAAA_AAAA };
            bins            WRITE_b = binsof(mode_cp.WRITE_b) && binsof( data_cp ) intersect { 32'hAAAA_AAAA };
            bins            ERROR_b = binsof(mode_cp.ERROR_b) && binsof( data_cp ) intersect { 32'hAAAA_AAAA };
            ignore_bins     i_b     = binsof(data_cp) intersect { 32'h5555_5555 , [32'h0000_0000 : 32'h5555_5554] , [32'h5555_5556 : 32'hAAAA_AAA9] , [32'hAAAA_AAAB : 32'hFFFF_FFFF] };
        }

        others_cross : cross mode_cp, data_cp {
            bins            BUSY_b  = binsof(mode_cp.BUSY_b)  && binsof( data_cp ) intersect { [32'h0000_0000 : 32'h5555_5554] , [32'h5555_5556 : 32'hAAAA_AAA9] , [32'hAAAA_AAAB : 32'hFFFF_FFFF] };
            bins            READ_b  = binsof(mode_cp.READ_b)  && binsof( data_cp ) intersect { [32'h0000_0000 : 32'h5555_5554] , [32'h5555_5556 : 32'hAAAA_AAA9] , [32'hAAAA_AAAB : 32'hFFFF_FFFF] };
            bins            WRITE_b = binsof(mode_cp.WRITE_b) && binsof( data_cp ) intersect { [32'h0000_0000 : 32'h5555_5554] , [32'h5555_5556 : 32'hAAAA_AAA9] , [32'hAAAA_AAAB : 32'hFFFF_FFFF] };
            bins            ERROR_b = binsof(mode_cp.ERROR_b) && binsof( data_cp ) intersect { [32'h0000_0000 : 32'h5555_5554] , [32'h5555_5556 : 32'hAAAA_AAA9] , [32'hAAAA_AAAB : 32'hFFFF_FFFF] };
            ignore_bins     i_b     = binsof(data_cp) intersect { 32'h5555_5555 , 32'hAAAA_AAAA };
        }

    endgroup : rand_2_1_cg

    function new (logic [31 : 0] min_addr = '0, logic [31 : 0] max_addr = '1);
        this.min_addr = min_addr;
        this.max_addr = max_addr;
        rand_2_1_cg = new();
    endfunction : new

    task analyze(string rand_d [], bit print_tr = '0);
        if( print_tr )
        begin
            $display("|    DATA    |    ADDR    | STROBE |     MODE     |");
            $display("| ---------- | ---------- | ------ | ------------ |");
        end
        foreach(rand_d[i])
        begin
            $sscanf(rand_d[i] , "| 0x%h | 0x%h | 0b%b | 0x%b |", data, addr, strob, mode);
            rand_2_1_cg.sample();
            if( print_tr )
                print_transaction();
        end
    endtask : analyze

    task print_transaction();
        $display("| 0x%h | 0x%h | 0b%b | 0x%b(%s) |", data, addr, strob, mode, mode == 3'b000 ? "BUSY " : mode == 3'b001 ? "READ " : mode == 3'b010 ? "WRITE" : mode == 3'b100 ? "ERROR" : "UNK  " );
    endtask : print_transaction

endclass : cover_2_1

module task_12_1;

    parameter   repeat_n = 10000;

    string      rand_tr [] = new[repeat_n];

    integer     i = 0;

    rand_1_1    rand_1_1_  = new( 32'h0500 , 32'h1000 );
    cover_2_1   cover_2_1_ = new( 32'h0500 , 32'h1000 );

    initial
    begin
        rand_1_1_.set_max_addr(32'h1000);
        rand_1_1_.set_min_addr(32'h0500);
        $display("|    DATA    |    ADDR    | STROBE |     MODE     |");
        $display("| ---------- | ---------- | ------ | ------------ |");
        for( i=0 ; i<repeat_n ; i++ )
        begin
            rand_tr[i] = rand_1_1_.make_rand();
            rand_1_1_.find_dist_data();
            rand_1_1_.print_transaction();
        end
        rand_1_1_.print_dist_data(repeat_n);
        cover_2_1_.analyze(rand_tr);
        $stop;
    end

endmodule : task_12_1
