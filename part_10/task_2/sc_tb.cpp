#include "sc_top.h"
#include "systemc.h"

int sc_main(int argc, char* argv[])
{
    sc_top sc_top_("sc_top_");
    sc_start();
    return 0;
}
