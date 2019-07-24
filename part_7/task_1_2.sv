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
        // вызываем для каждого поля метод конфигурации
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
        // вызываем для каждого поля метод конфигурации
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
        // вызываем для каждого поля метод конфигурации
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
        // вызываем для каждого поля метод конфигурации
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
        // вызываем для каждого поля метод конфигурации
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
        // вызываем для каждого поля метод конфигурации
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
        // вызываем для каждого поля метод конфигурации
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
