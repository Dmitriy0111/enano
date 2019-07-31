#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int *mem_c;
int mem_depth = 0;

int read_word_c(int addr, int* data) {
    if( addr < mem_depth )
    {
        *data = mem_c[addr];
        return 1;
    }
    else
        return 0;
} 

int write_word_c(int addr, int data) {
    if( addr < mem_depth )
    {
        mem_c[addr] = data;
        return 1;
    }
    else
        return 0;
} 

int create_mem(int depth) {
    mem_depth = depth;
    mem_c = (int *)malloc(sizeof(int)*depth);
    if( mem_c == NULL )
        return 0;
    else
        return 1;
}
