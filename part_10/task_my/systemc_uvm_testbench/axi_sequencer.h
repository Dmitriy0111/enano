#ifndef AXI_SEQUENCER__H
#define AXI_SEQUENCER__H

#include "systemc.h"
#include "tlm.h"
#include "uvm.h"

template <class REQ>
class axi_sequencer : public uvm::uvm_sequencer<REQ>
{
    public:
        UVM_COMPONENT_PARAM_UTILS(axi_sequencer<REQ>);

        axi_sequencer( uvm::uvm_component_name name ) : uvm::uvm_sequencer<REQ>( name )
        {
            std::cout << sc_core::sc_time_stamp() << ": Constructed " << name << std::endl;
        }

};

#endif // AXI_SEQUENCER__H
