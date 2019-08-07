#ifndef AXI_PACKET__H
#define AXI_PACKET__H

#include "systemc.h"
#include "tlm.h"
#include "uvm.h"

class axi_packet : public uvm::uvm_sequence_item
{
    public:
        UVM_OBJECT_UTILS(axi_packet);

        axi_packet(const std::string& name = "packet") { ; }
        axi_packet() { ; }
        virtual ~axi_packet() { }

        virtual void do_print(const uvm::uvm_printer& printer) const
        {
            printer.print_field_int( "ADDR " , addr  );
            printer.print_field_int( "DATA " , data  );
            printer.print_field_int( "SIZE " , size  );
            printer.print_field_int( "LEN  " , len   );
            printer.print_field_int( "BURST" , burst );
            printer.print_field_int( "RW   " , rw    );
        }

        virtual void do_copy(const uvm::uvm_object& rhs)
        {
            const axi_packet* drhs = dynamic_cast<const axi_packet*>(&rhs);
            if (!drhs) { std::cerr << "ERROR in do_copy" << std::endl; return; }
            addr  = drhs->addr;
            data  = drhs->data;
            size  = drhs->size;
            len   = drhs->len;
            burst = drhs->burst;
            rw    = drhs->rw;
        }

        virtual bool do_compare(const uvm_object& rhs, const uvm::uvm_comparer*) const
        {
            const axi_packet* drhs = dynamic_cast<const axi_packet*>(&rhs);
            if (!drhs) { std::cerr << "ERROR in do_compare" << std::endl; return true; }
            if (!(addr  == drhs->addr )) return false;
            if (!(data  == drhs->data )) return false;
            if (!(size  == drhs->size )) return false;
            if (!(len   == drhs->len  )) return false;
            if (!(burst == drhs->burst)) return false;
            if (!(rw    == drhs->rw   )) return false;
            return true;
        }

        std::string convert2string() const
        {
            std::ostringstream str;
            str << "| ADDR  | 0x" << addr  << hex
                << "| DATA  | 0x" << data  << hex
                << "| SIZE  | 0x" << size  << hex
                << "| LEN   | 0x" << len   << hex
                << "| BURST | 0x" << burst << hex
                << "| RW    | "   << ( ( rw == 1 ) ? "READ" : "WRITE" ) << endl;
            return str.str();
        }

    public:
        sc_bv<32  >     addr;
        sc_bv<1024>     data;
        sc_bv<3   >     size;
        sc_bv<8   >     len;
        sc_bv<2   >     burst;
        sc_bv<1   >     rw;
};

#endif // AXI_PACKET__H
