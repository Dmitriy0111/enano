//  Class: uart_driver
//
`ifndef UART_DRIVER__SV
`define UART_DRIVER__SV

class uart_driver #(type seq_item = uart_item, type uart_vif = virtual uart_if) extends uvm_driver #(seq_item);
    `uvm_component_param_utils( uart_driver #( seq_item , uart_vif ) );

    integer     cycle = 0;
    
    uart_vif    uart_vif_;
    
    extern function new(string name = "uart_driver", uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual function void end_of_elaboration_phase(uvm_phase phase);
    extern virtual function void start_of_simulation_phase(uvm_phase phase);
    extern virtual task reset_phase(uvm_phase phase);
    extern virtual task configure_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    
endclass : uart_driver

function uart_driver::new(string name = "uart_driver", uvm_component parent = null);
    super.new(name,parent);
endfunction : new

function void uart_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction : build_phase

function void uart_driver::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    uvm_config_db#(uart_vif)::get(this, "", "uart_vif", uart_vif_);
endfunction : connect_phase

function void uart_driver::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    if( uart_vif_ == null )
        `uvm_fatal("UART|DRV|NO_CON","Virtual interface not connected to the actual interface instance");
endfunction : end_of_elaboration_phase

function void uart_driver::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
endfunction : start_of_simulation_phase

task uart_driver::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    phase.raise_objection(this);
    phase.drop_objection(this);
endtask : reset_phase

task uart_driver::configure_phase(uvm_phase phase);
    super.configure_phase(phase);
    phase.raise_objection(this,"");
    phase.drop_objection(this);
endtask : configure_phase

task uart_driver::run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever 
    begin
        seq_item item;
        seq_item_port.get_next_item(item);
        @(posedge uart_vif_.clk);
        cycle++;
        item.N = cycle;
        uart_vif_.tx_data   = item.tx_data;
        uart_vif_.stop      = item.stop;
        uart_vif_.parity_en = item.parity_en;
        uart_vif_.baudrate  = 50_000_000 / item.baudrate;
        uart_vif_.req = '1;
        `uvm_info   (
                        "UART|DRV",
                        { "Request transaction sending\n" , item.convert2string() },
                        UVM_LOW
                    );
        @(posedge uart_vif_.req_ack);
        uart_vif_.req = '0;
        repeat(item.delay) @(posedge uart_vif_.clk);
        seq_item_port.item_done();
    end
endtask : run_phase

`endif // UART_DRIVER__SV
