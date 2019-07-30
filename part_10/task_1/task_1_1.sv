import "DPI-C" context function read_word(input int addr, output int data);
import "DPI-C" context function write_word(input int addr, input int data);

module task_1_1;

    parameter   mem_aw = 10;

    logic   [31 : 0]    test_mem    [2**mem_aw-1 : 0];

    initial
    begin
        
    end

endmodule : task_1_1
