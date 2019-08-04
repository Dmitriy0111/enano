module counter
(
    input   wire    [0 : 0]     clk,
    input   wire    [0 : 0]     resetn,
    input   wire    [0 : 0]     dir,
    output  wire    [7 : 0]     c_out
);

    reg     [7 : 0]     c_int;  // internal counter

    assign c_out = c_int;

    always @(posedge clk, negedge resetn)
        if( !resetn )
            c_int <= 8'h00;
        else
            c_int <= c_int + ( dir == 1'b1 ? 8'b1 : -8'b1 ); 

endmodule // counter
