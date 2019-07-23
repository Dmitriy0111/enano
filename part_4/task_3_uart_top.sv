
module top();

    import      uvm_pkg::*;
    `include    "uvm_macros.svh"

    import task_3_uart_pkg::*;

    uart_if     uart_if_();

    initial begin
        uart_if_.clk = 0;
        uart_if_.resetn = 1;
        forever
            #(10) uart_if_.clk = !uart_if_.clk;
    end

    initial begin
        uvm_config_db#(virtual uart_if)::set(uvm_root::get(), "", "uart_if", uart_if_);
        run_test("run_item_test");
    end

endmodule

// module task_3_uart;
// 
//     uart_item    uart_item_0 = new( "[ UART Transactor 0 ]" );
// 
//     initial
//     begin
//         repeat(100)
//         begin
//             assert( uart_item_0.randomize() ) else $stop;
//             uart_item_0.print();
//         end
//         $stop;
//     end
// 
// endmodule : task_3_uart
