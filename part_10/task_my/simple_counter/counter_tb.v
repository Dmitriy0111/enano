`timescale 1ns/1ns

module counter_tb();

    parameter   T = 10,
                rst_delay = 7;

    reg     [0 : 0]     clk;
    reg     [0 : 0]     resetn;
    reg     [0 : 0]     dir;
    wire    [7 : 0]     c_out;

    counter
    counter_0
    (
        .clk    ( clk       ),
        .resetn ( resetn    ),
        .dir    ( dir       ),
        .c_out  ( c_out     )
    );

    initial
    begin
        clk = 1'b0;
        forever
            #(T/2) clk = !clk;
    end

    initial
    begin
        resetn = 1'b0;
        repeat(rst_delay) @(posedge clk);
        resetn = 1'b1;
    end

    initial
    begin
        dir = 1'b0;
        @(posedge resetn);
        repeat(400) @(posedge clk);
        dir = 1'b1;
        repeat(400) @(posedge clk);
        $stop;
    end

    initial
    begin
        forever
        begin
            @(posedge clk);
            $display("%tns, dir = %s, c_out = 0x%h", $time, dir ? "+" : "-", c_out);
        end
    end

    initial
    begin
        $dumpfile("simple_counter_tb.vcd");
        $dumpvars(0,counter_tb);
    end

endmodule // counter_tb
