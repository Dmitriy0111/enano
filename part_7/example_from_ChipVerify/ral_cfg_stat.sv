class ral_cfg_stat extends uvm_reg;
    `uvm_object_utils(ral_cfg_stat)

    uvm_reg_field   state;
   
    function new(string name = "ral_cfg_stat");
      super.new(name, 32, build_coverage(UVM_NO_COVERAGE));
    endfunction : new
   
    virtual function void build();
        this.state = uvm_reg_field::type_id::create("state",, get_full_name());
   
        this.state.configure(this, 2, 0, "RO", 0, 1'h0, 0, 0, 0);
    endfunction : build
    
endclass : ral_cfg_stat