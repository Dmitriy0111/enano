class A;

    integer data [];

    function new(integer data_size);
        data = new[data_size];
        foreach(data[i])
            data[i] = $random();
    endfunction : new

endclass : A

class B extends A;

    function new(integer data_size);
        super.new(data_size);
    endfunction : new

endclass : B

class C;

    function new ();
    endfunction : new

    function integer sum_of_data_A(A A_);
        integer ret_res;
        ret_res = 0;
        foreach(A_.data[i])
            ret_res += A_.data[i];
        return ret_res;
    endfunction : sum_of_data_A

endclass : C

module task_5;

    B   B_ = new(200);
    C   C_ = new();

    initial
    begin
        integer sum;
        sum = 0;
        foreach(B_.data[i])
            sum += B_.data[i];
        $display("sum = %d, sum from C_ = %d", sum, C_.sum_of_data_A(B_) );
        $stop;
    end

endmodule : task_5
