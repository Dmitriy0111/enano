#include "systemc.h"

SC_MODULE(sc_hello) {
    SC_CTOR(sc_hello){

    }
    void say_hello() {
        cout << "Hello World!\n";
    }
};

int sc_main(int argc, char* argv[])
{
    sc_hello sc_hello_("sc_hello_");
    sc_hello_.say_hello();
    return 0;
}
