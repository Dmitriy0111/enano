#ifndef AXI_SUBSCRIBER__H
#define AXI_SUBSCRIBER__H

#include "systemc.h"
#include "tlm.h"
#include "uvm.h"

#include "axi_packet.h"

class axi_subscriber : public uvm::uvm_subscriber<axi_packet>
{
    public:
        UVM_COMPONENT_UTILS(axi_subscriber);
        
        axi_subscriber( uvm_component_name name ) : uvm_subscriber<axi_packet>( name )
        {
	        std::cout << sc_time_stamp() << ": constructor " << name << std::endl;
        }

        void write(const axi_packet& p)
        {
            std::cout << sc_time_stamp() << ": " << name() << " received packet " << std::endl;
        }
        
};

#endif // AXI_SUBSCRIBER__H
