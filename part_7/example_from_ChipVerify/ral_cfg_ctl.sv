class ral_cfg_ctl extends uvm_reg;
    `uvm_object_utils(ral_cfg_ctl)
    
    rand    uvm_reg_field   mod_en;
    rand    uvm_reg_field   bl_yellow;
    rand    uvm_reg_field   bl_red;
    rand    uvm_reg_field   profile;
   
    function new(string name = "traffic_cfg_ctrl");
        super.new(name, 32, build_coverage(UVM_NO_COVERAGE));
    endfunction : new
   
    virtual function void build();
        this.mod_en     = uvm_reg_field::type_id::create("mod_en",,   get_full_name());
        this.bl_yellow  = uvm_reg_field::type_id::create("bl_yellow",,get_full_name());
        this.bl_red     = uvm_reg_field::type_id::create("bl_red",,   get_full_name());
        this.profile    = uvm_reg_field::type_id::create("profile",,  get_full_name());
   
        this.mod_en     .configure(this, 1, 0, "RW", 0, 1'h0, 1, 0, 0);
        this.bl_yellow  .configure(this, 1, 1, "RW", 0, 3'h4, 1, 0, 0);
        this.bl_red     .configure(this, 1, 2, "RW", 0, 1'h0, 1, 0, 0);
        this.profile    .configure(this, 1, 3, "RW", 0, 1'h0, 1, 0, 0);
    endfunction : build

endclass : ral_cfg_ctl
