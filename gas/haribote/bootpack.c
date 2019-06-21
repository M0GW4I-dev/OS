void _io_hlt(void);

void Harimain(void)
{
    fin:
        _io_hlt();
        goto fin;
}