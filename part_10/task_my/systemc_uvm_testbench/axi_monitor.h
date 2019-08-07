#ifndef AXI_MONITOR__H
#define AXI_MONITOR__H

#include "systemc.h"
#include "tlm.h"
#include "uvm.h"

#include "axi_if.h"

class axi_monitor : public uvm::uvm_monitor
{
    public:
        UVM_COMPONENT_UTILS(axi_monitor);

        uvm::uvm_analysis_port<axi_packet> mon_ap;

        axi_if* vif;

        axi_monitor(uvm::uvm_component_name name) : uvm_monitor(name), mon_ap("mon_ap"), vif(0),
        {
            std::cout << sc_core::sc_time_stamp() << ": Constructed " << name << std::endl;
        }

        void build_phase(uvm::uvm_phase& phase)
        {
            std::cout << sc_core::sc_time_stamp() << ": build_phase " << name() << std::endl;

            uvm::uvm_monitor::build_phase(phase);

            if (!uvm::uvm_config_db<axi_if*>::get(this, "*", "vif", vif))
                UVM_FATAL(name(), "Virtual interface not defined! Simulation aborted!");

        }

        void run_phase( uvm::uvm_phase& phase )
        {
            axi_packet p;

            while (true) // monitor forever
            {
                wait(10, SC_NS);
                mon_ap.write(p);

            }
        }

};

#endif // AXI_MONITOR__H
