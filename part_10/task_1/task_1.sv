import "DPI-C" context function int read_word_c(input int addr, output int data);
import "DPI-C" context function int write_word_c(input int addr, input int data);
import "DPI-C" context function int create_mem(input int depth);

module task_1;

    parameter   mem_aw = 10;

    logic   [31 : 0]    mem_sv[];

    initial
    begin
        mem_sv = new[2**mem_aw];
        if( mem_sv.size() == '0 )
        begin
            $display("mem_sv is not created!");
            $stop;
        end
        if( !create_mem( 2**mem_aw ) )
        begin
            $display("mem_c is not created!");
            $stop;
        end
        for(integer i = 0 ; i < 2 ** mem_aw ; i++ )
        begin
            integer data;
            data = $random;
            write_word_c(i,data);
            write_word_sv(i,data);
        end
        for(integer i = 0 ; i < 2 ** mem_aw ; i++ )
        begin
            integer data;
            read_word_c( i , data );
            $display("mem_c [%d] = 0x%h", i , data);
            $display("mem_sv[%d] = 0x%h", i , read_word_sv( i ) );
            $display("mem_c and mem_sv [%d] is %s", i, data == read_word_sv( i ) ? "equal" : "not equal" );
        end
    end

    function void write_word_sv(logic [31 : 0] addr, logic [31 : 0] data);
        mem_sv[addr] = data;
    endfunction : write_word_sv
    function integer read_word_sv(logic [31 : 0] addr);
        return mem_sv[addr];
    endfunction : read_word_sv

endmodule : task_1
