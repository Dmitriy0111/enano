module bottom(
  input [30:0]  DATA0,
  input [30:0]  DATA1,
  input         CLK0,
  input         CLK1,
  output reg [30:0] DATAO
);

 wire [30:0] mx_data;
 reg enable_data;
 
 assign mx_data = DATA0[2] ? DATA0 : DATA1;
 
 always @(posedge CLK1) DATAO <= mx_data;
 
 
 assign mx_data = DATA0[5] ? DATA0 : DATA1;


endmodule


module top(
  input [31:0]  DATA0,
  input [31:0]  DATA1,
  input         CLK0,
  input         CLK1,
  output [31:0] DATAO
);

  reg [31:0] d0,d1;

always @(posedge CLK0) d0<=DATA0;
always @(posedge CLK1) d1<=DATA1;

 bottom bottom1(
   d0,
   d1,
   CLK0,
   CLK1,
   DATAO
 );

endmodule