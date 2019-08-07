#ifndef AXI_ENV__H
#define AXI_ENV__H

#include "systemc.h"
#include "tlm.h"
#include "uvm.h"

#include "axi_agent.h"
#include "axi_packet.h"
#include "axi_sequence.h"

class axi_env : public uvm::uvm_env
{
    public:
        UVM_COMPONENT_UTILS(axi_env);

        // instances
        axi_agent*          agt_0;
        axi_subscriber*     axi_subscriber_0;

        axi_env( uvm::uvm_component_name name) : uvm::uvm_env(name)
        {
            std::cout << sc_core::sc_time_stamp() << ": Constructed " << name << std::endl;
        }

        void build_phase(uvm::uvm_phase& phase)
        {
            std::cout << sc_core::sc_time_stamp() << ": build_phase " << name() << std::endl;

            uvm::uvm_env::build_phase(phase);

            agt_0 = axi_agent::type_id::create("agt_0", this);
            assert(agt_0);

            uvm::uvm_config_db<int>::set(this, "agt_0", "is_active", uvm::UVM_ACTIVE);

            axi_subscriber_0 = axi_subscriber::type_id::create("axi_subscriber_0", this);
            assert(axi_subscriber_0);

            uvm::uvm_config_db<uvm_object_wrapper*>
            ::set(this,"agt_0.axi_sequencer.run_phase","default_axi_sequence",
            axi_sequence<axi_packet>::type_id::get());
        }

        void connect_phase(uvm::uvm_phase& phase)
        {
            std::cout << sc_core::sc_time_stamp() << ": connect_phase " << name() << std::endl;

            agt_0->monitor->mon_ap.connect(axi_subscriber_0);
        }

};

#endif // AXI_ENV__H
