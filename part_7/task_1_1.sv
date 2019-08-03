import      uvm_pkg::*;
`include    "uvm_macros.svh"

class ctrl extends uvm_reg;
    `uvm_object_utils(ctrl)

    //defining register fields
    rand    uvm_reg_field   st1;
    rand    uvm_reg_field   st2;
    rand    uvm_reg_field   sum1;
            uvm_reg_field   unused;

    function new(string name = "ctrl");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction : new

    virtual function void build();
        st1     = uvm_reg_field::type_id::create( "st1"    );
        st2     = uvm_reg_field::type_id::create( "st2"    );
        sum1    = uvm_reg_field::type_id::create( "sum1"   );
        unused  = uvm_reg_field::type_id::create( "unused" );
        // вызываем для каждого поля метод конфигурации
        st1     .configure( this , 2  , 0  , "RW" , 0 , 2'b00                   , 1 , 1 , 0 );
        st2     .configure( this , 6  , 3  , "RO" , 0 , 6'b00_0000              , 1 , 1 , 0 );
        sum1    .configure( this , 8  , 9  , "RO" , 0 , 8'b0000_0000            , 1 , 1 , 0 );
        unused  .configure( this , 16 , 17 , "RO" , 0 , 16'b0000_0000_0000_0000 , 1 , 1 , 0 );
    endfunction : build
    
endclass : ctrl

class data_in extends uvm_reg;
    `uvm_object_utils(data_in)

    //defining register fields
    rand    uvm_reg_field   data;

    function new(string name = "data_in");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction : new

    virtual function void build();
        data = uvm_reg_field::type_id::create( "data" );
        // вызываем для каждого поля метод конфигурации
        data.configure( this , 32 , 0 , "RW" , 0 , 32'h00_00_00_00 , 1 , 1 , 0 );
    endfunction : build
    
endclass : data_in

class data_out extends uvm_reg;
    `uvm_object_utils(data_out)

    //defining register fields
    rand    uvm_reg_field   data;

    function new(string name = "data_out");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction : new

    virtual function void build();
        data = uvm_reg_field::type_id::create( "data" );

        data.configure( this , 32 , 0 , "RO" , 0 , 32'h00_00_00_00 , 1 , 1 , 0 );
    endfunction : build
    
endclass : data_out

class task_1_1_reg_block extends uvm_reg_block;
    `uvm_object_utils(task_1_1_reg_block)
    
    // defining registers
    rand    ctrl        ctrl_reg;
    rand    data_in     data_in_reg;
    rand    data_out    data_out_reg;

    uvm_reg_map task_1_map;

    function new(string name = "task_1_1_reg_block");
        super.new(name, UVM_NO_COVERAGE);
    endfunction

    virtual function void build();
        // creating
        ctrl_reg        = ctrl      ::type_id::create( "ctrl"     );
        data_in_reg     = data_in   ::type_id::create( "data_in"  );
        data_out_reg    = data_out  ::type_id::create( "data_out" );
        // configuring
        ctrl_reg        .configure(this, null, "");
        data_in_reg     .configure(this, null, "");
        data_out_reg    .configure(this, null, "");
        // building
        ctrl_reg        .build();
        data_in_reg     .build();
        data_out_reg    .build();

        task_1_map = create_map("task_1_map", 'h0, 4, UVM_LITTLE_ENDIAN);
        // adding register to map
        task_1_map.add_reg( ctrl_reg     , 32'h00000000 , "RW" );
        task_1_map.add_reg( data_in_reg  , 32'h0000001F , "RW" );
        task_1_map.add_reg( data_out_reg , 32'h0000004F , "RW" );
        
        lock_model();
    endfunction

endclass : task_1_1_reg_block
////////////////////////////////////////////////////////////////////
//  Class: ahb_pkt
//
class ahb_pkt extends uvm_sequence_item;

    rand    logic   [0  : 0]    rw;
    rand    logic   [31 : 0]    addr;
    rand    logic   [31 : 0]    data;

    `uvm_object_utils_begin(ahb_pkt)
        `uvm_field_int( rw   , UVM_DEFAULT )
        `uvm_field_int( addr , UVM_DEFAULT )
        `uvm_field_int( data , UVM_DEFAULT )
    `uvm_object_utils_end

    extern function new(string name = "ahb_pkt");
    extern function string convert2string();
    
endclass : ahb_pkt

function ahb_pkt::new(string name = "ahb_pkt");
    super.new(name);
endfunction : new

function string ahb_pkt::convert2string();

endfunction : convert2string

////////////////////////////////////////////////////////////////////
//  Class: reg2ahb_adapter
//
class reg2ahb_adapter extends uvm_reg_adapter;
    `uvm_object_utils(reg2ahb_adapter)

    extern function new(string name = "reg2ahb_adapter");
    extern virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    extern function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);

endclass : reg2ahb_adapter

function reg2ahb_adapter::new(string name = "reg2ahb_adapter");
    super.new(name);
endfunction : new

function uvm_sequence_item reg2ahb_adapter::reg2bus(const ref uvm_reg_bus_op rw);
    ahb_pkt pkt = ahb_pkt::type_id::create("pkt");
    pkt.rw   = ( rw.kind == UVM_WRITE ) ? '1 : '0;
    pkt.addr = rw.addr;
    pkt.data = rw.data;
    `uvm_info(this.get_name(), $sformatf("reg2bus : addr = 0x%h data = 0x%h ahb_rw = %s status = %s", rw.addr, rw.data, rw.kind.name(), rw.status.name() ), UVM_LOW)
    return pkt;
endfunction : reg2bus

function void reg2ahb_adapter::bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    ahb_pkt pkt;
    if( ! $cast( pkt , bus_item ) )
        `uvm_fatal(this.get_name(), "Failed to cast bus_item to pkt(ahb_item) ");
    rw.kind   = pkt.rw ? UVM_WRITE : UVM_READ ;
    rw.addr   = pkt.addr;
    rw.data   = pkt.data;
    `uvm_info(this.get_name(), $sformatf("bus2reg : addr = 0x%h data = 0x%h ahb_rw = %s status = %s", rw.addr, rw.data, rw.kind.name(), rw.status.name() ), UVM_LOW)
endfunction : bus2reg

////////////////////////////////////////////////////////////////////
//  Class: custom_predictor
//
class custom_predictor extends uvm_reg_predictor#(ahb_pkt);
    `uvm_component_utils(custom_predictor);

    extern function new(string name = "custom_predictor", uvm_component parent);

endclass : custom_predictor

function custom_predictor::new(string name = "custom_predictor", uvm_component parent);
    super.new(name, parent);
endfunction : new

////////////////////////////////////////////////////////////////////
//  Class: reg_env
//
class reg_env extends uvm_env;
    `uvm_component_utils(reg_env);

    task_1_1_reg_block              task_1_1_reg_block_;
    reg2ahb_adapter                 reg2ahb_adapter_;
    uvm_reg_predictor   #(ahb_pkt)  reg_predictor;

    extern function new(string name = "reg_env", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass : reg_env

function reg_env::new(string name = "reg_env", uvm_component parent);
    super.new(name, parent);
endfunction : new

function void reg_env::build_phase(uvm_phase phase);
    super.build_phase(phase);
    task_1_1_reg_block_ = task_1_1_reg_block            ::type_id::create( "task_1_1_reg_block_" , this );
    reg2ahb_adapter_    = reg2ahb_adapter               ::type_id::create( "reg2ahb_adapter_"    , this );
    reg_predictor       = uvm_reg_predictor#(ahb_pkt)   ::type_id::create( "reg_predictor"       , this );

    task_1_1_reg_block_.build();
    task_1_1_reg_block_.lock_model();
endfunction : build_phase

function void reg_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    reg_predictor.map = task_1_1_reg_block_.default_map;
    reg_predictor.adapter = reg2ahb_adapter_;
endfunction : connect_phase

////////////////////////////////////////////////////////////////////
//  Class: task_1_1_test
//
class task_1_1_test extends uvm_test;

    reg_env     reg_env_0;

    `uvm_component_utils(task_1_1_test)

    extern function new(string name, uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);

endclass : task_1_1_test

function task_1_1_test::new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void task_1_1_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    reg_env_0 = reg_env::type_id::create("reg_env_0", this);

endfunction : build_phase

task task_1_1_test::run_phase(uvm_phase phase);
    super.run_phase(phase);
    #200;
endtask : run_phase
////////////////////////////////////////////////////////////////////
//  Module: task_1_1
//
module task_1_1;

    initial begin
        run_test("task_1_1_test");
    end

endmodule : task_1_1
