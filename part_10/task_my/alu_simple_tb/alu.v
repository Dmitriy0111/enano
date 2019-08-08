module alu
(
    input   wire    [6 : 0]     opcode,
    input   wire    [7 : 0]     op_0,
    input   wire    [7 : 0]     op_1,
    output  wire    [0 : 0]     zero_f,
    output  wire    [7 : 0]     result
);

    localparam          ADD_op = 7'b0000001,
                        SUB_op = 7'b0000010,
                        SRL_op = 7'b0000100,
                        SLL_op = 7'b0001000,
                        OR_op  = 7'b0010000,
                        AND_op = 7'b0100000,
                        XOR_op = 7'b1000000;

    reg     [7 : 0]     result_int;

    assign zero_f = ~|result_int; 
    assign result = result_int;

    always @(*)
    begin
        result_int = 8'h00;
        case( opcode )
            ADD_op  : result_int = op_0  + op_1;
            SUB_op  : result_int = op_0  - op_1;
            SRL_op  : result_int = op_0 << op_1;
            SLL_op  : result_int = op_0 >> op_1;
            OR_op   : result_int = op_0  | op_1;
            AND_op  : result_int = op_0  & op_1;
            XOR_op  : result_int = op_0  ^ op_1;
            default : ;
        endcase
    end

endmodule // alu
