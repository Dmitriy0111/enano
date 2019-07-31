#ifndef SC_TOP__C
#define SC_TOP__C

#include "systemc.h"
#include "sc_memory.h"
#include "sc_initiator.h"

SC_MODULE(sc_top)
{
    sc_initiator    *sc_initiator_;
    sc_memory       *sc_memory_;

    SC_CTOR(sc_top)
    {
        sc_initiator_ = new sc_initiator("sc_initiator_");
        sc_memory_ = new sc_memory("sc_memory_");

        sc_initiator_->socket.bind( sc_memory_->socket );
    }
};

#endif // SC_TOP__C
