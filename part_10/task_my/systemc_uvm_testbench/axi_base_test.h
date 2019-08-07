#ifndef AXI_TEST__H
#define AXI_TEST__H

#include "systemc.h"
#include "tlm.h"
#include "uvm.h"
#include "axi_sequence.h"

class axi_base_test : public uvm::uvm_test {

    public:
        UVM_COMPONENT_UTILS(axi_base_test);

        axi_env*        env;
        axi_sequence*   seq;

        axi_base_test(uvm::uvm_component_name name) : env(0),
        {
            std::cout << sc_core::sc_time_stamp() << ": Constructed " << name << std::endl;
        }

        void build_phase(uvm::uvm_phase& phase) {
            std::cout << sc_core::sc_time_stamp() << ": build_phase " << name() << std::endl;
            uvm::uvm_monitor::build_phase(phase);
            env = axi_env::type_id::create("env", this);
        }

        void main_phase(uvm::uvm_phase& phase) {
            this->starting_phase->raise_objection(this);
            seq = axi_sequence::type_id::create("seq");
            seq.start(env->agt_0->seqr);
            this->starting_phase->drop_objection(this);
        }

};

#endif // AXI_TEST__H