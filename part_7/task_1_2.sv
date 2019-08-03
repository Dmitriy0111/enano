import      uvm_pkg::*;
`include    "uvm_macros.svh"

class intr0 extends uvm_reg;
    `uvm_object_utils(intr0)

    //defining register fields
    rand    uvm_reg_field   rdy0;
            uvm_reg_field   unused;

    function new(string name = "intr0");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction : new

    virtual function void build();
        rdy0    = uvm_reg_field::type_id::create( "rdy0"   );
        unused  = uvm_reg_field::type_id::create( "unused" );

        rdy0    .configure( this , 1  , 0 , "RW" , 0 , 1'b0            , 1 , 1 , 0 );
        unused  .configure( this , 31 , 1 , "RO" , 0 , 31'h00_00_00_00 , 1 , 1 , 0 );
    endfunction : build
    
endclass : intr0

class intr1 extends uvm_reg;
    `uvm_object_utils(intr1)

    //defining register fields
    rand    uvm_reg_field   rdy1;
            uvm_reg_field   unused;

    function new(string name = "intr1");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction : new

    virtual function void build();
        rdy1    = uvm_reg_field::type_id::create( "rdy0"   );
        unused  = uvm_reg_field::type_id::create( "unused" );

        rdy1    .configure( this , 1  , 0 , "RW" , 0 , 1'b0            , 1 , 1 , 0 );
        unused  .configure( this , 31 , 1 , "RO" , 0 , 31'h00_00_00_00 , 1 , 1 , 0 );
    endfunction : build
    
endclass : intr1

class intr2 extends uvm_reg;
    `uvm_object_utils(intr2)

    //defining register fields
    rand    uvm_reg_field   rdy2;
            uvm_reg_field   unused;

    function new(string name = "intr2");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction : new

    virtual function void build();
        rdy2    = uvm_reg_field::type_id::create( "rdy0"   );
        unused  = uvm_reg_field::type_id::create( "unused" );

        rdy2    .configure( this , 1  , 0 , "RW" , 0 , 1'b0            , 1 , 1 , 0 );
        unused  .configure( this , 31 , 1 , "RO" , 0 , 31'h00_00_00_00 , 1 , 1 , 0 );
    endfunction : build
    
endclass : intr2

class intr3 extends uvm_reg;
    `uvm_object_utils(intr3)

    //defining register fields
    rand    uvm_reg_field   rdy3;
            uvm_reg_field   unused;

    function new(string name = "intr3");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction : new

    virtual function void build();
        rdy3    = uvm_reg_field::type_id::create( "rdy3"   );
        unused  = uvm_reg_field::type_id::create( "unused" );

        rdy3    .configure( this , 1  , 0 , "RW" , 0 , 1'b0            , 1 , 1 , 0 );
        unused  .configure( this , 31 , 1 , "RO" , 0 , 31'h00_00_00_00 , 1 , 1 , 0 );
    endfunction : build
    
endclass : intr3

class mmin extends uvm_reg;
    `uvm_object_utils(mmin)

    //defining register fields
    rand    uvm_reg_field   min;
            uvm_reg_field   unused;

    function new(string name = "mmin");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction : new

    virtual function void build();
        min    = uvm_reg_field::type_id::create( "min"    );
        unused = uvm_reg_field::type_id::create( "unused" );

        min     .configure( this , 16 , 16 , "RW" , 0 , 16'h00_00 , 1 , 1 , 0 );
        unused  .configure( this , 16 , 0  , "RO" , 0 , 16'h00_00 , 1 , 1 , 0 );
    endfunction : build
    
endclass : mmin

class mmax extends uvm_reg;
    `uvm_object_utils(mmax)

    //defining register fields
    rand    uvm_reg_field   max;
            uvm_reg_field   unused;

    function new(string name = "mmax");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction : new

    virtual function void build();
        max    = uvm_reg_field::type_id::create( "max"    );
        unused = uvm_reg_field::type_id::create( "unused" );

        max     .configure( this , 16 , 0  , "RW" , 0 , 16'h00_00 , 1 , 1 , 0 );
        unused  .configure( this , 16 , 16 , "RO" , 0 , 16'h00_00 , 1 , 1 , 0 );
    endfunction : build
    
endclass : mmax

class en_w extends uvm_reg;
    `uvm_object_utils(en_w)

    //defining register fields
    rand    uvm_reg_field   en;
            uvm_reg_field   unused;

    function new(string name = "en_w");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction : new

    virtual function void build();
        en      = uvm_reg_field::type_id::create( "en"     );
        unused  = uvm_reg_field::type_id::create( "unused" );

        en      .configure( this , 1  , 0 , "RW" , 0 , 1'b0            , 1 , 1 , 0 );
        unused  .configure( this , 31 , 1 , "RO" , 0 , 31'h00_00_00_00 , 1 , 1 , 0 );
    endfunction : build
    
endclass : en_w

class task_1_2_reg_block extends uvm_reg_block;
    `uvm_object_utils(task_1_2_reg_block)
    
    // defining registers
    rand    intr0       intr0_reg;
    rand    intr1       intr1_reg;
    rand    intr2       intr2_reg;
    rand    intr3       intr3_reg;
    rand    mmin        mmin_reg;
    rand    mmax        mmax_reg;
    rand    en_w        en_w_reg;

    uvm_reg_map task_1_map;

    function new(string name = "task_1_2_reg_block");
        super.new(name, UVM_NO_COVERAGE);
    endfunction

    virtual function void build();
        // creating
        intr0_reg   = intr0     ::type_id::create( "intr0_reg" );
        intr1_reg   = intr1     ::type_id::create( "intr1_reg" );
        intr2_reg   = intr2     ::type_id::create( "intr2_reg" );
        intr3_reg   = intr3     ::type_id::create( "intr3_reg" );
        mmin_reg    = mmin      ::type_id::create( "mmin_reg"  );
        mmax_reg    = mmax      ::type_id::create( "mmax_reg"  );
        en_w_reg    = en_w      ::type_id::create( "en_w_reg"  );
        // configuring
        intr0_reg   .configure(this, null, "");
        intr1_reg   .configure(this, null, "");
        intr2_reg   .configure(this, null, "");
        intr3_reg   .configure(this, null, "");
        mmin_reg    .configure(this, null, "");
        mmax_reg    .configure(this, null, "");
        en_w_reg    .configure(this, null, "");
        // building
        intr0_reg   .build();
        intr1_reg   .build();
        intr2_reg   .build();
        intr3_reg   .build();
        mmin_reg    .build();
        mmax_reg    .build();
        en_w_reg    .build();

        task_1_map = create_map("task_1_map", 'h0, 4, UVM_LITTLE_ENDIAN);
        // adding register to map
        task_1_map.add_reg( intr0_reg , 32'h00000000 , "RW" );
        task_1_map.add_reg( intr1_reg , 32'h0000002F , "RW" );
        task_1_map.add_reg( intr2_reg , 32'h0000004F , "RW" );
        task_1_map.add_reg( intr3_reg , 32'h0000006F , "RW" );
        task_1_map.add_reg( mmin_reg  , 32'h0000008F , "RW" );
        task_1_map.add_reg( mmax_reg  , 32'h000000AF , "RW" );
        task_1_map.add_reg( en_w_reg  , 32'h000000BF , "RW" );
        
        lock_model();
    endfunction

endclass : task_1_2_reg_block
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
//  Class: reg_env
//
class reg_env extends uvm_env;
    `uvm_component_utils(reg_env);

    task_1_2_reg_block              task_1_2_reg_block_;
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
    task_1_2_reg_block_ = task_1_2_reg_block            ::type_id::create( "task_1_2_reg_block_" , this );
    reg2ahb_adapter_    = reg2ahb_adapter               ::type_id::create( "reg2ahb_adapter_"    , this );
    reg_predictor       = uvm_reg_predictor#(ahb_pkt)   ::type_id::create( "reg_predictor"       , this );

    task_1_2_reg_block_.build();
    task_1_2_reg_block_.lock_model();
endfunction : build_phase

function void reg_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    reg_predictor.map = task_1_2_reg_block_.default_map;
    reg_predictor.adapter = reg2ahb_adapter_;
endfunction : connect_phase

////////////////////////////////////////////////////////////////////
//  Class: task_1_2_test
//
class task_1_2_test extends uvm_test;

    reg_env     reg_env_0;

    `uvm_component_utils(task_1_2_test)

    extern function new(string name, uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);

endclass : task_1_2_test

function task_1_2_test::new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void task_1_2_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    reg_env_0 = reg_env::type_id::create("reg_env_0", this);

endfunction : build_phase

task task_1_2_test::run_phase(uvm_phase phase);
    super.run_phase(phase);
    #200;
endtask : run_phase
////////////////////////////////////////////////////////////////////
//  Module: task_1_2
//
module task_1_2;

    initial begin
        run_test("task_1_2_test");
    end

endmodule : task_1_2
