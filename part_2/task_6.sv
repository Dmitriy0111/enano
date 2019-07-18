interface simple_if #(parameter addr_w = 8, data_w = 8);
    logic   [addr_w-1 : 0]  addr;
    logic   [data_w-1 : 0]  data_in;
    logic   [data_w-1 : 0]  data_out;
    logic   [0        : 0]  req;
    logic   [0        : 0]  req_ack;
endinterface : simple_if

module task_6;

    simple_if   #( 8  ,  8 )    s_if_0();
    simple_if   #( 16 , 16 )    s_if_1();
    simple_if   #( 32 , 32 )    s_if_2();

    initial
    begin
        s_if_0.addr     = $random();
        s_if_0.data_in  = $random();
        s_if_0.data_out = $random();
        s_if_0.req      = $random();
        s_if_0.req_ack  = $random();
        
        s_if_1.addr     = $random();
        s_if_1.data_in  = $random();
        s_if_1.data_out = $random();
        s_if_1.req      = $random();
        s_if_1.req_ack  = $random();

        s_if_2.addr     = $random();
        s_if_2.data_in  = $random();
        s_if_2.data_out = $random();
        s_if_2.req      = $random();
        s_if_2.req_ack  = $random();
        #10
        $stop;
    end

endmodule : task_6
