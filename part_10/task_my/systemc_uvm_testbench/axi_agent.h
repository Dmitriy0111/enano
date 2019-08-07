#ifndef AXI_AGENT__H
#define AXI_AGENT__H

#include "systemc.h"
#include "tlm.h"
#include "uvm.h"

#include "axi_sequencer.h"
#include "axi_driver.h"
#include "axi_monitor.h"
#include "axi_packet.h"
#include "axi_agent_cfg.h"

class axi_agent : public uvm::uvm_agent
{
    public:
        UVM_COMPONENT_UTILS(axi_agent);

        axi_sequencer<axi_packet>*  seqr;
        axi_driver<axi_packet>*     drv;
        axi_monitor*                mon;
        axi_agent_cfg*              agt_cfg;

        axi_agent( uvm::uvm_component_name name ) : uvm_agent(name), seqr(0), drv(0), mon(0) 
        {
            std::cout << sc_core::sc_time_stamp() << ": Constructed " << name << std::endl;
        }

        void build_phase(uvm::uvm_phase& phase)
        {
            std::cout << sc_core::sc_time_stamp() << ": build_phase " << name() << std::endl;
            uvm::uvm_agent::build_phase(phase);
            
            if( ! uvm::uvm_config_db<uvm_object_wrapper*>::get(this,"","agt_cfg",agt_cfg) )
                UVM_INFO(get_name(), "Agent configuration not found", UVM_NONE);
            if( agt_cfg == NULL ) {
                agt_cfg = new axi_agent_cfg("agt_cfg");
                agt_cfg.set_default();
            }
            if ( agt_cfg.is_active() ) {

                if( agt_cfg.is_master() ) {
                    UVM_INFO(get_name(), "agent is master", UVM_NONE);
                    drv = axi_driver<axi_packet>::type_id::create("drv", this);
                    assert(drv);
                    seqr = axi_sequencer<axi_packet>::type_id::create("seqr", this);
                    assert(seqr);
                }
                else
                {
                    UVM_INFO(get_name(), "agent is slave", UVM_NONE);
                }

            }
            else
                UVM_INFO(get_name(), "agent is passive", UVM_NONE);

            mon = axi_monitor::type_id::create("mon", this);
            assert(mon);
        }

        void connect_phase(uvm::uvm_phase& phase)
        {
            std::cout << sc_core::sc_time_stamp() << ": connect_phase " << name() << std::endl;

            if ( agt_cfg.is_active() )
            {
                drv->seq_item_port.connect(seqr->seq_item_export);
            }
        }

};

#endif // AXI_AGENT__H
