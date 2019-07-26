`ifndef APB_ITEM__SV
`define APB_ITEM__SV

//  Class: apb_item
//
class apb_item #(parameter addrw=32, parameter dataw=32) extends uvm_sequence_item;

    typedef enum { apb_read , apb_write }   apb_rw;

    rand    logic   [addrw-1 : 0]   addr;
    rand    logic   [dataw-1 : 0]   data;
    rand    apb_rw                  apb_rw_;

    `uvm_object_utils_begin(apb_item)
        `uvm_field_int  ( addr   ,           UVM_DEFAULT )
        `uvm_field_int  ( data   ,           UVM_DEFAULT )
        `uvm_field_enum ( apb_rw , apb_rw_ , UVM_DEFAULT )
    `uvm_object_utils_end

    extern function new(string name = "apb_item");
    extern function string convert2string();
    
endclass : apb_item

function apb_item::new(string name = "apb_item");
    super.new(name);
endfunction: new

function string apb_item::convert2string();
    string s;
    $sformat(
                s,
                "| 0x%h | 0x%h | %s |",
                addr,
                data,
                apb_rw_
            );
    return s;
endfunction : convert2string

`endif // APB_ITEM__SV
