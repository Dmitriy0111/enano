module task_1;

    parameter   repeat_n = 100,
                T = 10;

    logic   [0 : 0]     clk;    // clock signal

    initial
    begin
        clk = '0;
        $display("Clock generation start!");
        while(1)
        begin
            #(T/2) clk = !clk;
        end
    end

    initial
    begin
        repeat( repeat_n ) @(posedge clk);
        $stop;
    end

endmodule : task_1
