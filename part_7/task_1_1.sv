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
        // вызываем для каждого поля метод конфигурации
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
