module task_4;

    parameter   repeat_n = 10;

    typedef struct{
        integer     n;
        integer     range[2];
    } range_;

    range_  ranges[$];

    function bit ranges_test(range_ ranges_t[$]);
        integer i;
        integer j;
        bit     ret_v;
        ret_v = '1;
        
        for( i=0; i<ranges_t.size() ; i++ )
            for( j=i; j<ranges_t.size() ; j++ )
                if( i != j )
                    if  ( 
                            ( ( ranges_t[i].range[1] > ranges_t[j].range[0] ) && ( ranges_t[j].range[0] >= ranges_t[i].range[0] ) ) ||
                            ( ( ranges_t[j].range[1] > ranges_t[i].range[0] ) && ( ranges_t[i].range[0] >= ranges_t[j].range[0] ) )
                        )
                    begin
                        $display("[ %3d ]( %7d : %7d ) and [ %3d ]( %7d : %7d ) would be crossed", i, ranges_t[i].range[0], ranges_t[i].range[1], j, ranges_t[j].range[0], ranges_t[j].range[1]);
                        ret_v = '0;
                    end

        return ret_v;
    endfunction : ranges_test

    task print_ranges(range_ ranges_t[$]);
        foreach(ranges_t[i])
            $display("[ %3d ]( %7d : %7d )", ranges_t[i].n, ranges_t[i].range[0], ranges_t[i].range[1]);
    endtask : print_ranges

    initial
    begin
        integer i;
        integer range_0;
        integer range_1;

        for( i=0; i<repeat_n; i++ )
        begin
            //range_0 = $urandom_range(0,2000);
            //range_1 = $urandom_range(0,2000);
            range_0 = i * 20 - $urandom_range(0,30);
            range_1 = i * 20 + $urandom_range(0,30);
            if( range_0 > range_1 )
            begin
                automatic integer h_i;
                h_i = range_0;
                range_0 = range_1;
                range_1 = h_i;
            end
            ranges.push_back( { i , '{ range_0 , range_1 } } );
        end
        print_ranges(ranges);
        ranges_test(ranges);
        $stop;
    end

endmodule : task_4
