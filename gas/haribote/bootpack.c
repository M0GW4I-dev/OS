void io_hlt();
void write_mem8(int addr, int data);

int Main(){
    int i;
    for(i=0xa0000; i<=0xaffff; i++) {
        write_mem8(i, i & 15);
    }

    for (;;) {
        io_hlt();
    }
}
