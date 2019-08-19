class ral_cfg_timer extends uvm_reg;
    `uvm_object_utils(ral_cfg_timer)
    
    uvm_reg_field   timer;
   
    function new(string name = "traffic_cfg_timer");
      super.new(name, 32,build_coverage(UVM_NO_COVERAGE));
    endfunction : new
   
    virtual function void build();
        this.timer = uvm_reg_field::type_id::create("timer",,get_full_name());
   
        this.timer.configure(this, 32, 0, "RW", 0, 32'hCAFE1234, 1, 0, 1);
        this.timer.set_reset('h0, "SOFT");
    endfunction : build

endclass : ral_cfg_timer
