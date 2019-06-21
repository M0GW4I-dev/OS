AS = i686-elf-as
LD = i686-elf-ld


%.bin: %.s %.ld Makefile
	$(AS) -o $*.o $*.s
	$(LD) -T $*.ld -o $*.bin $*.o

myos.img: ipl.bin haribote.bin
	mformat -f 1440 -C -B ipl.bin -i $@
	mcopy -i $@ haribote.bin ::

run: myos.img
	qemu-system-i386 -drive format=raw,if=floppy,file=myos.img -monitor stdio

.PHONY: clean

clean:
	rm *.img *.o *.bin
