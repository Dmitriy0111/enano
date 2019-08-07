`ifndef AXI_ITEM__SV
`define AXI_ITEM__SV

//  Class: axi_item
//
class axi_item extends uvm_sequence_item;

    typedef enum { AXI_READ , AXI_WRITE } axi_rw;

    rand    logic   [31 : 0]    addr;
    rand    logic   [7  : 0]    data [$];
    rand    axi_rw              axi_rw_;
    rand    logic   [2  : 0]    size;
    rand    logic   [7  : 0]    len;
    rand    logic   [1  : 0]    burst;

    constraint len_size_c {
        size * len <= 1024;
        len % 2**size == 0;
        len != 0;
    }

    constraint data_c {
        data.size == len;
    }

    `uvm_object_utils_begin(axi_item);
        `uvm_field_int          (          addr    , UVM_DEFAULT )
        `uvm_field_queue_int    (          data    , UVM_DEFAULT )
        `uvm_field_int          (          size    , UVM_DEFAULT )
        `uvm_field_int          (          len     , UVM_DEFAULT )
        `uvm_field_int          (          burst   , UVM_DEFAULT )
        `uvm_field_enum         ( axi_rw , axi_rw_ , UVM_DEFAULT )
    `uvm_object_utils_end

    extern function        new(string name = "axi_item");
    extern function string convert2string();

endclass : axi_item

function axi_item::new(string name = "axi_item");
    super.new(name);
endfunction : new

function string axi_item::convert2string();
    string s;
    s = super.convert2string();
    $sformat(s, "%s| ADDR  = <0x%h> " , s, addr    );
    $sformat(s, "%s| RW    = <%s> "    , s, axi_rw_ );
    $sformat(s, "%s| SIZE  = <0x%h> " , s, size    );
    $sformat(s, "%s| LEN   = <0x%h> " , s, len     );
    $sformat(s, "%s| BURST = <0x%h> " , s, burst   );
    if( axi_rw_ == AXI_WRITE )
    begin
        $sformat(s, "%s| DATA  = "         , s          );
        foreach(data[i])
            $sformat(s, "%s<0x%h>", s, data[i]);
    end
    $sformat(s, "%s|\n", s );
    return s;
endfunction : convert2string

`endif // AXI_ITEM__SV
