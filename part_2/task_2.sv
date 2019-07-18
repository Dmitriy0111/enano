module task_2;

    parameter   repeat_n = 100;

    integer     a_0 [integer];
    integer     a_1 [integer];

    initial
    begin
        //
        repeat( $urandom_range(repeat_n/2,repeat_n) )
            a_0[$urandom_range(0,255)] = $urandom_range(0,255);
        //
        repeat( $urandom_range(repeat_n/2,repeat_n) )
            a_1[$urandom_range(0,255)] = $urandom_range(0,255);
        print_a_ar(a_0);
        print_a_ar(a_1);
        comp_a_ar(a_0, a_1);
        $stop;
    end

    task print_a_ar(integer a_[integer]);
        $display("");
        for(integer i=0; i <=255 ; i++)
            if( a_.exists(i) )
                $display("%d | %d", i, a_[i]);
    endtask : print_a_ar

    task comp_a_ar(integer a_c0[integer], integer a_c1[integer]);
        $display("");
        for(integer i=0; i <= 255; i++)
            case( { a_c0.exists(i) ? 1'b1 : 1'b0 , a_c1.exists(i) ? 1'b1 : 1'b0 } )
                2'b11   :   $display(" %d | a_c0 exists = %d, a_c1 exists = %d, elements is %s", i, a_c0[i], a_c1[i], a_c0[i] == a_c1[i] ? "equal" : "not_equal" );
                2'b10   :   $display(" %d | a_c0 exists = %d, a_c1 doesn't exists",              i, a_c0[i]                                                      );
                2'b01   :   $display(" %d | a_c1 exists = %d, a_c0 doesn't exists",              i, a_c1[i]                                                      );
                2'b00   :   $display(" %d | a_c0 and a_c1 doesn't exists",                       i                                                               );
                default :   ;
            endcase
    endtask : comp_a_ar

endmodule : task_2
