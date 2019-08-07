#ifndef AXI_AGENT_CFG__H
#define AXI_AGENT_CFG__H

#include "systemc.h"
#include "uvm.h"

class axi_agent_cfg : public uvm::uvm_object
{
    public:
        UVM_OBJECT_UTILS(axi_agent_cfg);

        bool    is_master;
        bool    is_active;

        axi_agent_cfg(uvm::uvm_object_name name)
        {
            std::cout << sc_core::sc_time_stamp() << ": Constructed " << name << std::endl;
        }

        void set_default() {
            is_active = true;
            is_master = true;
        }

        void set_passive() {
            is_active = false;
        }

        void set_master() {
            is_active = true;
            is_master = true;
        }

        void set_slave() {
            is_active = true;
            is_master = false;
        }

};

#endif // AXI_AGENT_CFG__H
