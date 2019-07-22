class rand_1_4;

    typedef enum logic [1 : 0]  { READ = 2'b01 , WRITE = 2'b10 } mode_v;

    rand    logic   [63 : 0]    data    [$];
    rand    logic   [31 : 0]    addr    [$];
    rand    logic   [7  : 0]    strob   [$];
    rand    logic   [1  : 0]    mode;

    rand    integer             N;
    //  MODE = 01 -> READ 
    //  MODE = 10 -> WRITE 

    integer                     dist_a[5] = {'0,'0,'0,'0,'0};

    constraint strob_c {
        strob.size() == N;
        
        foreach( strob[i] ) {
            if( i == 0 ) {
                strob[0] inside { 8'h01 , 8'h03 , 8'h07 , 0'h0F , 8'h1F , 8'h3F , 8'h7F , 8'hFF };
            } else if( i == N-1 ) {
                strob[$] inside { 8'hFF , 8'hFE , 8'hFC , 0'hF8 , 8'hF0 , 8'hE0 , 8'hC0 , 8'h80 };
            } else {
                strob[i] inside { 8'hFF };
            }
        }
    }

    constraint N_c {
        N > 0;
        N < 16;
    }

    constraint addr_c {
        addr.size() == N;
        foreach( addr[i] ) {
            addr[i] <= 32'hFFFF_FFFF;
            addr[i] >= 32'h0000_0000;
        }
    }

    constraint N2addr_data_strobe {
        solve N before addr, data, strob;
    }

    constraint mode_c {
        mode inside { READ , WRITE };
    }

    constraint data_c {
        data.size() == N;
        foreach( data[i] ) {
            data[i] dist   { 
                            [64'h0000_0000_0000_0001 : 64'h5555_5555_5555_5554] :/ 12, 
                            [64'h5555_5555_5555_5556 : 64'hAAAA_AAAA_AAAA_AAA9] :/ 12, 
                            [64'hAAAA_AAAA_AAAA_AAAB : 64'hFFFF_FFFF_FFFF_FFFE] :/ 12, 
                            64'h5555_5555_5555_5555 :/ 25, 
                            64'hAAAA_AAAA_AAAA_AAAA :/ 25,
                            64'h0000_0000_0000_0000 :/ 6,
                            64'hFFFF_FFFF_FFFF_FFFF :/ 6
                        };
        }
    }

    function string make_rand(ref integer N , ref logic [63 : 0] data [$], ref logic [31  : 0] addr [$], ref logic [7 : 0] strob [$], ref logic [1 : 0] mode );
        string ret_str;
        assert( this.randomize() ) else $stop;
        // data.delete();
        // addr.delete();
        // strob.delete();

        // foreach( this.data[i] )
        //     data.push_back(this.data[i]);
        // foreach( this.addr[i] )
        //     addr.push_back(this.addr[i]);
        // foreach( this.strob[i] )
        //     strob.push_back(this.strob[i]);
        N = this.N;
        data = this.data;
        addr = this.addr;
        strob = this.strob;
        mode = this.mode;
        for(integer i=0;i<N;i++)
        $sformat(
                    ret_str,
                    "| 0x%1h | 0x%h | 0x%h | 0b%b | 0x%b(%s) |", 
                    N,
                    data[i], 
                    addr[i], 
                    strob[i], 
                    mode, 
                    mode == mode == 2'b01 ? "READ " : mode == 2'b10 ? "WRITE" : "UNK  " 
                );
        return ret_str;
    endfunction : make_rand

    function new ();
    endfunction : new

    task find_dist_data();
        foreach( data[i] )
        begin
            if  ( 
                    ( data[i] != 64'h0000_0000_0000_0000 ) &&
                    ( data[i] != 64'hFFFF_FFFF_FFFF_FFFF ) &&
                    ( data[i] != 64'h5555_5555_5555_5555 ) &&
                    ( data[i] != 64'hAAAA_AAAA_AAAA_AAAA )
                )
                dist_a[0]++;
            if( data[i] == 64'h0000_0000_0000_0000 )
                dist_a[1]++;
            if( data[i] == 64'hFFFF_FFFF_FFFF_FFFF )
                dist_a[2]++;
            if( data[i] == 64'h5555_5555_5555_5555 )
                dist_a[3]++;
            if( data[i] == 64'hAAAA_AAAA_AAAA_AAAA )
                dist_a[4]++;
        end
    endtask : find_dist_data

    task print_dist_data(integer rand_n);
        $display(" %d, %2.2f%% ", dist_a[0] , dist_a[0] * 100.0 / ( dist_a[0] + dist_a[1] + dist_a[2] + dist_a[3] + dist_a[4] ) );
        $display(" %d, %2.2f%% ", dist_a[1] , dist_a[1] * 100.0 / ( dist_a[0] + dist_a[1] + dist_a[2] + dist_a[3] + dist_a[4] ) );
        $display(" %d, %2.2f%% ", dist_a[2] , dist_a[2] * 100.0 / ( dist_a[0] + dist_a[1] + dist_a[2] + dist_a[3] + dist_a[4] ) );
        $display(" %d, %2.2f%% ", dist_a[3] , dist_a[3] * 100.0 / ( dist_a[0] + dist_a[1] + dist_a[2] + dist_a[3] + dist_a[4] ) );
        $display(" %d, %2.2f%% ", dist_a[4] , dist_a[4] * 100.0 / ( dist_a[0] + dist_a[1] + dist_a[2] + dist_a[3] + dist_a[4] ) );
    endtask : print_dist_data

    task print_transaction();
        for( integer i=0; i<N; i++ )
            $display(
                        "| 0x%1h | 0x%h | 0x%h | 0b%b | 0x%b(%s) |", 
                        N,
                        data[i], 
                        addr[i], 
                        strob[i], 
                        mode, 
                        mode == mode == 2'b01 ? "READ " : mode == 2'b10 ? "WRITE" : "UNK  " 
                    );
    endtask : print_transaction

endclass : rand_1_4

class cover_2_4;

    typedef enum logic [1 : 0]  { READ = 2'b01 , WRITE = 2'b10 } mode_v;

    logic   [63 : 0]    data = '0;
    logic   [31 : 0]    addr = '0;
    logic   [7  : 0]    strob = '0;
    logic   [1  : 0]    mode = '0;
    integer             N = '0;

    covergroup rand_2_4_cg;

        mode_cp : coverpoint mode {
            bins            READ_b  = { READ  };
            bins            WRITE_b = { WRITE };
            illegal_bins    i_b     = { 0 , 3 };
        }

        mode_tr : coverpoint mode {
            // READ to others
            bins    READ2WRITE_b    = ( READ  => WRITE );
            bins    READ2READ_b     = ( READ  => READ  );
            // WRITE to others
            bins    WRITE2READ_b    = ( WRITE => READ  );
            bins    WRITE2WRITE_b   = ( WRITE => WRITE );
        }

        strob_cp : coverpoint strob {
            bins    strob_available[] = { 8'h01 , 8'h03 , 8'h07 , 0'h0F , 8'h1F , 8'h3F , 8'h7F , 8'hFF , 8'hFE , 8'hFC , 0'hF8 , 8'hF0 , 8'hE0 , 8'hC0 , 8'h80 };
        }

        data_cp : coverpoint data {
            bins    h5555_5555_5555_5555    =   {   64'h5555_5555_5555_5555 };
            bins    hAAAA_AAAA_AAAA_AAAA    =   {   64'hAAAA_AAAA_AAAA_AAAA };
            bins    h0000_0000_0000_0000    =   {   64'h0000_0000_0000_0000 };
            bins    hFFFF_FFFF_FFFF_FFFF    =   {   64'hFFFF_FFFF_FFFF_FFFF };
            bins    others                  =   { 
                                                    [64'h0000_0000_0000_0001 : 64'h5555_5555_5555_5554], 
                                                    [64'h5555_5555_5555_5556 : 64'hAAAA_AAAA_AAAA_AAA9], 
                                                    [64'hAAAA_AAAA_AAAA_AAAB : 64'hFFFF_FFFF_FFFF_FFFE] 
                                                };
        }

        h0000_0000_0000_0000_cross : cross mode_cp, data_cp {
            bins            READ_b  = binsof(mode_cp.READ_b)  && binsof( data_cp ) intersect { 64'h0000_0000_0000_0000 };
            bins            WRITE_b = binsof(mode_cp.WRITE_b) && binsof( data_cp ) intersect { 64'h0000_0000_0000_0000 };
            ignore_bins     i_b     = binsof(data_cp) intersect { 
                                                                    64'h5555_5555_5555_5555,
                                                                    64'hAAAA_AAAA_AAAA_AAAA,
                                                                    64'hFFFF_FFFF_FFFF_FFFF,
                                                                    [64'h0000_0000_0000_0001 : 64'h5555_5555_5555_5554], 
                                                                    [64'h5555_5555_5555_5556 : 64'hAAAA_AAAA_AAAA_AAA9], 
                                                                    [64'hAAAA_AAAA_AAAA_AAAB : 64'hFFFF_FFFF_FFFF_FFFE] 
                                                                };
        }

        h5555_5555_5555_5555_cross : cross mode_cp, data_cp {
            bins            READ_b  = binsof(mode_cp.READ_b)  && binsof( data_cp ) intersect { 64'h5555_5555_5555_5555 };
            bins            WRITE_b = binsof(mode_cp.WRITE_b) && binsof( data_cp ) intersect { 64'h5555_5555_5555_5555 };
            ignore_bins     i_b     = binsof(data_cp) intersect { 
                                                                    64'h0000_0000_0000_0000,
                                                                    64'hAAAA_AAAA_AAAA_AAAA,
                                                                    64'hFFFF_FFFF_FFFF_FFFF,
                                                                    [64'h0000_0000_0000_0001 : 64'h5555_5555_5555_5554], 
                                                                    [64'h5555_5555_5555_5556 : 64'hAAAA_AAAA_AAAA_AAA9], 
                                                                    [64'hAAAA_AAAA_AAAA_AAAB : 64'hFFFF_FFFF_FFFF_FFFE] 
                                                                };
        }

        hAAAA_AAAA_AAAA_AAAA_cross : cross mode_cp, data_cp {
            bins            READ_b  = binsof(mode_cp.READ_b)  && binsof( data_cp ) intersect { 64'hAAAA_AAAA_AAAA_AAAA };
            bins            WRITE_b = binsof(mode_cp.WRITE_b) && binsof( data_cp ) intersect { 64'hAAAA_AAAA_AAAA_AAAA };
            ignore_bins     i_b     = binsof(data_cp) intersect { 
                                                                    64'h0000_0000_0000_0000,
                                                                    64'h5555_5555_5555_5555,
                                                                    64'hFFFF_FFFF_FFFF_FFFF, 
                                                                    [64'h0000_0000_0000_0001 : 64'h5555_5555_5555_5554], 
                                                                    [64'h5555_5555_5555_5556 : 64'hAAAA_AAAA_AAAA_AAA9], 
                                                                    [64'hAAAA_AAAA_AAAA_AAAB : 64'hFFFF_FFFF_FFFF_FFFE] 
                                                                };
        }

        hFFFF_FFFF_FFFF_FFFF_cross : cross mode_cp, data_cp {
            bins            READ_b  = binsof(mode_cp.READ_b)  && binsof( data_cp ) intersect { 64'hFFFF_FFFF_FFFF_FFFF };
            bins            WRITE_b = binsof(mode_cp.WRITE_b) && binsof( data_cp ) intersect { 64'hFFFF_FFFF_FFFF_FFFF };
            ignore_bins     i_b     = binsof(data_cp) intersect { 
                                                                    64'h0000_0000_0000_0000,
                                                                    64'h5555_5555_5555_5555,
                                                                    64'hAAAA_AAAA_AAAA_AAAA,
                                                                    [64'h0000_0000_0000_0001 : 64'h5555_5555_5555_5554], 
                                                                    [64'h5555_5555_5555_5556 : 64'hAAAA_AAAA_AAAA_AAA9], 
                                                                    [64'hAAAA_AAAA_AAAA_AAAB : 64'hFFFF_FFFF_FFFF_FFFE] 
                                                                };
        }

        others_cross : cross mode_cp, data_cp {
            bins            READ_b  = binsof(mode_cp.READ_b)  && binsof( data_cp ) intersect    { 
                                                                                                    [64'h0000_0000_0000_0001 : 64'h5555_5555_5555_5554], 
                                                                                                    [64'h5555_5555_5555_5556 : 64'hAAAA_AAAA_AAAA_AAA9], 
                                                                                                    [64'hAAAA_AAAA_AAAA_AAAB : 64'hFFFF_FFFF_FFFF_FFFE] 
                                                                                                };
            bins            WRITE_b = binsof(mode_cp.WRITE_b) && binsof( data_cp ) intersect    { 
                                                                                                    [64'h0000_0000_0000_0001 : 64'h5555_5555_5555_5554], 
                                                                                                    [64'h5555_5555_5555_5556 : 64'hAAAA_AAAA_AAAA_AAA9], 
                                                                                                    [64'hAAAA_AAAA_AAAA_AAAB : 64'hFFFF_FFFF_FFFF_FFFE] 
                                                                                                };
            ignore_bins     i_b     = binsof(data_cp) intersect { 64'h0000_0000_0000_0000 , 64'h5555_5555_5555_5555 , 64'hAAAA_AAAA_AAAA_AAAA , 64'hFFFF_FFFF_FFFF_FFFF };
        }

    endgroup : rand_2_4_cg

    covergroup rand_N_2_4_cg;

        mode_cp : coverpoint mode {
            bins            READ_b  = { READ  };
            bins            WRITE_b = { WRITE };
            illegal_bins    i_b     = { 0 , 3 };
        }

        N_cp : coverpoint N {
            bins    N_b [] = { [ 1 : 15 ] };
        }

        mode_N_cross : cross mode_cp, N_cp;

    endgroup : rand_N_2_4_cg

    function new ();
        rand_2_4_cg = new();
        rand_N_2_4_cg = new();
    endfunction : new

    task analyze( integer N , logic [63 : 0] data [$], logic [31 : 0] addr [$], logic [7 : 0] strob [$], logic [1 : 0] mode  );
        this.N = N;
        this.mode = mode;
        for( integer i=0 ; i<this.N ; i++ )
        begin
            this.data = data[i];
            this.addr = addr[i];
            this.strob = strob[i];
            rand_2_4_cg.sample();
        end
        rand_N_2_4_cg.sample();
    endtask : analyze

endclass : cover_2_4

module task_12_4;

    parameter   repeat_n = 1000;

    string      rand_tr [] = new[repeat_n];

    integer     i = 0;

    rand_1_4    rand_1_4_  = new(  );
    cover_2_4   cover_2_4_ = new(  );

    integer             N;
    logic   [63 : 0]    data [$];
    logic   [31 : 0]    addr [$];
    logic   [7  : 0]    strob [$];
    logic   [1  : 0]    mode;

    initial
    begin
        $display("|  N  |        DATA        |    ADDR    |   STROBE   |     MODE    |");
        $display("| --- | ------------------ | ---------- | ---------- | ----------- |");
        for( i=0 ; i<repeat_n ; i++ )
        begin
            rand_tr[i] = rand_1_4_.make_rand(N,data,addr,strob,mode);
            rand_1_4_.find_dist_data();
            rand_1_4_.print_transaction();
            cover_2_4_.analyze(N,data,addr,strob,mode);
        end
        rand_1_4_.print_dist_data(repeat_n);
        $stop;
    end

endmodule : task_12_4
