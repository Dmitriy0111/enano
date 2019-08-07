`ifndef AHB_ITEM__SV
`define AHB_ITEM__SV

//  Class: ahb_item
//
class ahb_item extends uvm_sequence_item;

    typedef enum { ahb_read , ahb_write }   ahb_rw;

    rand    logic   [31 : 0]    addr;
    rand    logic   [31 : 0]    data;
    rand    ahb_rw              ahb_rw_;

    `uvm_object_utils_begin(ahb_item)
        `uvm_field_int  ( addr   ,           UVM_DEFAULT )
        `uvm_field_int  ( data   ,           UVM_DEFAULT )
        `uvm_field_enum ( ahb_rw , ahb_rw_ , UVM_DEFAULT )
    `uvm_object_utils_end

    extern function        new(string name = "ahb_item");
    extern function string convert2string();
    
endclass : ahb_item

function ahb_item::new(string name = "ahb_item");
    super.new(name);
endfunction: new

function string ahb_item::convert2string();
    string s;
    s = super.convert2string();
    $sformat(s, "ADDR : <0x%0h>\n", addr);
    $sformat(s, "RW   : <%s>\n", ahb_rw_);
    $sformat(s, "DATA : <0x%0h>\n", data);
    return s;
endfunction : convert2string

`endif // AHB_ITEM__SV
