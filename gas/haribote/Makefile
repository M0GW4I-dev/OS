AS = i686-elf-as
ASFLAGS = --32
LD = i686-elf-ld
LDFLAGS = -m elf_i386
CC = i686-elf-gcc
CFLAGS = -m32 -nostdlib


%.bin: %.s %.ld Makefile
	$(AS) $(ASFLAGS) -o $*.o $*.s
	$(LD) $(LDFLAGS) -T $*.ld -o $*.bin $*.o

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $*.c

func.o: func.s
	$(AS) $(ASFLAGS) -o $@ func.s

bootpack.bin: bootpack.ld bootpack.o func.o Makefile
	$(LD) -v $(LDFLAGS) -Map bootpack.map -T bootpack.ld -o $@ func.o bootpack.o


myos.img: ipl.bin bootpack.bin head.bin
	mformat -f 1440 -C -B ipl.bin -i $@
	cat head.bin bootpack.bin > sys.bin
	mcopy -i $@ sys.bin ::
	

run: myos.img
	qemu-system-i386 -drive format=raw,if=floppy,file=myos.img -monitor stdio

run_test: myos.img
	qemu-system-i386 -fda myos.img
		
.PHONY: clean

clean:
	rm *.img *.o *.bin
