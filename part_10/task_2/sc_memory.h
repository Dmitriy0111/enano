#ifndef SC_MEMORY__C
#define SC_MEMORY__C

#define SC_INCLUDE_DYNAMIC_PROCESS

#include "systemc.h"
using namespace std;
using namespace sc_core;
using namespace sc_dt;

#include "tlm.h"
#include "tlm_utils/simple_target_socket.h"

struct sc_memory : sc_module
{

    enum { SIZE = 256 };
    int* mem;

    tlm_utils::simple_target_socket<sc_memory> socket;


    SC_CTOR(sc_memory) : socket("socket")
    {
        mem = (int *)malloc(sizeof(int)*SIZE);
        socket.register_b_transport( this , &sc_memory::b_transport);
        for( int i = 0 ; i < SIZE ; i++ )
            mem[i] = 0xAA000000 | ( rand() % 256 );
    }

    virtual void b_transport(tlm::tlm_generic_payload& trans, sc_time& delay)
    {
        tlm::tlm_command cmd = trans.get_command();
        sc_dt::uint64 addr = trans.get_address() / 4;
        unsigned char* ptr = trans.get_data_ptr();
        unsigned int len = trans.get_data_length();
        unsigned char* byt = trans.get_byte_enable_ptr();
        unsigned int wid = trans.get_streaming_width();
        mem[0] = 10;

        if( ( addr >= sc_dt::uint64(SIZE) ) || ( byt != 0 ) || ( len > 4 ) || ( wid < len ) )
            SC_REPORT_ERROR("TLM-2", "Target does not support given generic payload transacton");
        
        if( cmd == tlm::TLM_READ_COMMAND )
            memcpy( ptr , &mem[addr] , len );
        else if( cmd == tlm::TLM_WRITE_COMMAND )
            memcpy( &mem[addr] , ptr , len );
        
        trans.set_response_status( tlm::TLM_OK_RESPONSE );
    }

};

#endif // SC_MEMORY__C
