module counter
#(
    parameter                   cw = 8
)(
    input   wire    [0    : 0]  clk,
    input   wire    [0    : 0]  resetn,
    input   wire    [0    : 0]  dir,
    output  wire    [cw-1 : 0]  c_out
);

    reg     [cw-1 : 0]  c_int;  // internal counter

    assign c_out = c_int;

    always @(posedge clk, negedge resetn)
        if( !resetn )
            c_int <= { cw {1'b0} };
        else
            c_int <= c_int + ( dir ? 1'b1 : -1'b1 ); 

endmodule // counter
