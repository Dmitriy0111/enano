#ifndef AXI_DRIVER__H
#define AXI_DRIVER__H

#include "systemc.h"
#include "tlm.h"
#include "uvm.h"

#include "axi_packet.h"
#include "axi_if.h"

template <class REQ>
class axi_driver : public uvm::uvm_driver<REQ>
{
    public:
        UVM_COMPONENT_PARAM_UTILS(axi_driver<REQ>);
        
        axi_if*     vif;
        
        axi_driver( uvm::uvm_component_name name ) : uvm::uvm_driver<REQ>(name)
        {
            std::cout << sc_core::sc_time_stamp() << ": Constructed " << name << std::endl;
        }
        
        void build_phase(uvm::uvm_phase& phase)
        {
            std::cout << sc_core::sc_time_stamp() << ": build_phase " << this->name() << std::endl;

            uvm_driver<REQ>::build_phase(phase);

            if (!uvm_config_db<axi_if*>::get(this, "*", "vif", vif))
                UVM_FATAL(this->name(), "Virtual interface not defined! Simulation aborted!");
        }
        
        void run_phase(uvm::uvm_phase& phase)
        {
            std::cout << sc_core::sc_time_stamp() << ": " << this->name() << " " << phase.get_name() << "..." << std::endl;

            REQ req, rsp;

            while(true) // execute all sequences
            {
                this->seq_item_port->get_next_item(req);
                drive_transfer(req);
                rsp.set_id_info(req);
                this->seq_item_port->item_done();
                this->seq_item_port->put_response(rsp);
            }
        }
        
        void drive_transfer(const REQ& p)
        {
            sc_core::wait(10, sc_core::SC_NS);
        }

};

#endif // AXI_DRIVER__H
