//  Class: uart_monitor
//
`ifndef UART_MONITOR__SV
`define UART_MONITOR__SV

class uart_monitor #(type seq_item = uart_item, type uart_vif = virtual uart_if) extends uvm_monitor;
    `uvm_component_param_utils( uart_monitor #( seq_item , uart_vif ) );

    uvm_analysis_port   #( seq_item          )  mon_analysis_port;
    uvm_analysis_port   #( uvm_sequence_item )  item_collected_port;
    uvm_analysis_port   #( seq_item          )  predictor_port;
    
    uart_vif uart_vif_;
    
    extern function new(string name = "uart_monitor", uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual function void end_of_elaboration_phase(uvm_phase phase);
    extern virtual function void start_of_simulation_phase(uvm_phase phase);
    extern virtual task reset_phase(uvm_phase phase);
    extern virtual task configure_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
    
endclass : uart_monitor

function uart_monitor::new(string name = "uart_monitor", uvm_component parent = null);
    super.new(name,parent);
    mon_analysis_port = new( "mon_analysis_port" , this );
    predictor_port    = new( "predictor_port"    , this );
endfunction : new

function void uart_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_port = new( "item_collected_port" , this );
endfunction : build_phase

function void uart_monitor::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    uvm_config_db#(uart_vif)::get(this, "", "uart_vif", uart_vif_);
endfunction : connect_phase

function void uart_monitor::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    if( uart_vif_ == null )
        `uvm_fatal("UART|MON|NO_CON","Virtual interface not connected to the actual interface instance");
endfunction : end_of_elaboration_phase

function void uart_monitor::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
endfunction : start_of_simulation_phase

task uart_monitor::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    phase.raise_objection(this);
    phase.drop_objection(this);
endtask : reset_phase

task uart_monitor::configure_phase(uvm_phase phase);
    super.configure_phase(phase);
    phase.raise_objection(this,"");
    phase.drop_objection(this);
endtask : configure_phase

task uart_monitor::run_phase(uvm_phase phase);
    logic   [15 : 0]    baudrate;
    integer             tx_c;
    super.run_phase(phase);
    @(posedge uart_vif_.resetn);
    forever 
    begin
        uart_item uart_item_;
        @(negedge uart_vif_.uart_tx);
        tx_c = 0;
        baudrate = uart_vif_.baudrate;
        uart_item_ = uart_item::type_id::create("uart_item_", this);
        repeat(baudrate) @( posedge uart_vif_.clk );    // START
        repeat(8)                                       // DATA
        begin
            repeat(baudrate)
            begin
                @( posedge uart_vif_.clk );
                tx_c += uart_vif_.uart_tx;
            end
            uart_item_.tx_data = { ( tx_c > baudrate / 2 ) ? 1'b1 : 1'b0 , uart_item_.tx_data[7 : 1] };
            tx_c = '0;
        end
        repeat(baudrate) @( posedge uart_vif_.clk );    // STOP
        mon_analysis_port.write(uart_item_);
        `uvm_info ("UART/MON",$sformatf("Collect item: \n%s",uart_item_.convert2string()),UVM_LOW)
    end
endtask : run_phase

`endif // UART_MONITOR__SV
