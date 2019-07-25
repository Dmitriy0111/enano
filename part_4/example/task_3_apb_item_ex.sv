`ifndef APB_ITEM__SV
`define APB_ITEM__SV

class apb_item extends uvm_sequence_item;

    typedef enum {READ, WRITE} kind_e;

    rand bit    [31 : 0]    addr;
    rand logic  [31 : 0]    data;
    rand kind_e             kind;

    `uvm_object_utils_begin(apb_item)
        `uvm_field_int(addr, UVM_ALL_ON | UVM_NOPACK);
        `uvm_field_int(data, UVM_ALL_ON | UVM_NOPACK);
        `uvm_field_enum(kind_e,kind, UVM_ALL_ON | UVM_NOPACK);
    `uvm_object_utils_end

    function new (string name = "apb_item");
        super.new(name);
    endfunction

    function string convert2string();
        return $sformatf("kind=%s addr=%0h data=%0h",kind,addr,data);
    endfunction

endclass : apb_item

`endif // APB_ITEM__SV
