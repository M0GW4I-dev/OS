.code32

.global _io_hlt

.text

_io_hlt: # void _io_hlt(void);
    hlt
    ret