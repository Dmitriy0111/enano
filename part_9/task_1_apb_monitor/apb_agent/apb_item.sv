`ifndef APB_ITEM__SV
`define APB_ITEM__SV

//  Class: apb_item
//
class apb_item extends uvm_sequence_item;

    typedef enum { apb_read , apb_write }   apb_rw;

    rand    logic   [31 : 0]    addr;
    rand    logic   [31 : 0]    data;
    rand    apb_rw              apb_rw_;

    `uvm_object_utils_begin(apb_item)
        `uvm_field_int  ( addr   ,           UVM_DEFAULT )
        `uvm_field_int  ( data   ,           UVM_DEFAULT )
        `uvm_field_enum ( apb_rw , apb_rw_ , UVM_DEFAULT )
    `uvm_object_utils_end

    extern function        new(string name = "apb_item");
    extern function string convert2string();
    
endclass : apb_item

function apb_item::new(string name = "apb_item");
    super.new(name);
endfunction: new

function string apb_item::convert2string();
    string s;
    s = super.convert2string();
    $sformat(s, "ADDR : <0x%0h>\n", addr);
    $sformat(s, "RW   : <%s>\n", apb_rw_);
    $sformat(s, "DATA : <0x%0h>\n", data);
    return s;
endfunction : convert2string

`endif // APB_ITEM__SV
