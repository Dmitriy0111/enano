module task_3;

    parameter   repeat_n = 1000;

    integer     numbers [$];

    initial
    begin
        repeat( repeat_n )
            numbers.push_back( $random() );
        print_all_queue(numbers);
        $display("max = %d", max_find(numbers) );
        $display("min = %d", min_find(numbers) );
        $stop;
    end

    function integer max_find (integer data[$]);
        integer max;
        max = '1;

        foreach( data[i] )
        begin
            max = max < data[i] ? data[i] : max;
        end
        return max;
    endfunction : max_find

    function integer min_find (integer data[$]);
        integer min;
        min = ~( 1'b1 << 32 );

        foreach( data[i] )
        begin
            min = min > data[i] ? data[i] : min;
        end
        return min;
    endfunction : min_find

    task print_all_queue(integer data[$]);
        foreach(data[i])
            $display("%d", data[i]);
    endtask : print_all_queue

endmodule : task_3
