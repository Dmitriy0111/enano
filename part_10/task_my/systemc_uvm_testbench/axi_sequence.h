#ifndef AXI_SEQUENCE__H
#define AXI_SEQUENCE__H

#include "systemc.h"
#include "tlm.h"
//#include "uvm.h"

template <typename REQ = uvm::uvm_sequence_item, typename RSP = REQ>
class axi_sequence : public uvm::uvm_sequence<REQ,RSP>
{
    public:
        UVM_OBJECT_PARAM_UTILS(axi_sequence<REQ,RSP>);

        axi_sequence( const std::string& name ) : uvm::uvm_sequence<REQ,RSP>( name )
        {
            std::cout << sc_core::sc_time_stamp() << ": Constructed " << name << std::endl;
        }

        void pre_body()
        {
            // raise objection if started as a root sequence
            if(this->starting_phase != NULL)
                this->starting_phase->raise_objection(this);
        }

        void body()
        {
            REQ* req;
            RSP* rsp;

            UVM_INFO(this->get_name(), "Starting axi_sequence", uvm::UVM_MEDIUM);

            for(int i = 1; i < 10; i++)
            {
                req = new REQ();
                rsp = new RSP();

                std::cout << sc_core::sc_time_stamp() << ": " << this->get_full_name() << " start_item value " << i << std::endl;

                this->start_item(req);
                this->finish_item(req);
                this->get_response(rsp);
            }

            UVM_INFO(this->get_name(), "Finishing axi_sequence", uvm::UVM_MEDIUM);
        }

        void post_body()
        {
            // drop objection if started as a root axi_sequence
            if(this->starting_phase != NULL)
                this->starting_phase->drop_objection(this);
        }

};

#endif // AXI_SEQUENCE__H
