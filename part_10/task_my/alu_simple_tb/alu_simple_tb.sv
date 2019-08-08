`timescale 1ns/1ns

module alu_simple_tb();

    parameter           T = 10;

    localparam          ADD_op = 7'b0000001,
                        SUB_op = 7'b0000010,
                        SRL_op = 7'b0000100,
                        SLL_op = 7'b0001000,
                        OR_op  = 7'b0010000,
                        AND_op = 7'b0100000,
                        XOR_op = 7'b1000000;

    reg     [6 : 0]     opcode;
    reg     [7 : 0]     op_0;
    reg     [7 : 0]     op_1;
    wire    [0 : 0]     zero_f;
    wire    [7 : 0]     result;

    alu 
    alu_0
    (
        .opcode     ( opcode    ),
        .op_0       ( op_0      ),
        .op_1       ( op_1      ),
        .zero_f     ( zero_f    ),
        .result     ( result    )
    );

    initial
    begin
        logic   [7 : 0]     exp_result;
        repeat( 100 )
        begin
            opcode = 1 << $urandom_range(0,6);
            $write("Random opcode = %s, ",  ( opcode == ADD_op ) ? "ADD_op" : 
                                            ( opcode == SUB_op ) ? "SUB_op" : 
                                            ( opcode == SRL_op ) ? "SRL_op" :
                                            ( opcode == SLL_op ) ? "SLL_op" :
                                            ( opcode == OR_op  ) ? "OR_op " :
                                            ( opcode == AND_op ) ? "AND_op" :
                                            ( opcode == XOR_op ) ? "XOR_op" :
                                                                   "UNK_op");
            op_0 = $urandom_range(0,255);
            $write("op_0 = 0x%h, ", op_0);
            op_1 = $urandom_range(0,255);
            $write("op_1 = 0x%h, ", op_1);
            exp_result = 0;
            case( opcode )
                ADD_op  : exp_result = op_0  + op_1;
                SUB_op  : exp_result = op_0  - op_1;
                SRL_op  : exp_result = op_0 << op_1;
                SLL_op  : exp_result = op_0 >> op_1;
                OR_op   : exp_result = op_0  | op_1;
                AND_op  : exp_result = op_0  & op_1;
                XOR_op  : exp_result = op_0  ^ op_1;
            endcase
            $write("expected result = 0x%h, ", exp_result);
            #(T);
            $write("alu result = 0x%h", result);
            $display(" Test %s", exp_result == result ? "Pass" : "Fail" );
        end
        $stop;
    end
    
endmodule // alu_simple_tb
    