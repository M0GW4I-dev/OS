AS = i686-elf-as
LD = i686-elf-ld
CC = i686-elf-gcc
QEMU = qemu-system-i386 -format

%.o: %.S
	$(AS) -o $@ $*.S

%.o: %.c
	$(CC) -ffreestanding -c -o $@ $*.c

myos.bin: boot.o kernel.o Makefile
	$(CC) -T myos.ld -o $@ -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

.PHONY: clean bin_test create_img run

clean:
	rm myos.bin *.o

bin_test: myos.bin
	@./scripts/bin_test.sh

create_img: bin_test
	mkdir -p isodir/boot/grub
	cp myos.bin isodir/boot/myos.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	i386-elf-grub-mkrescue -o myos.iso isodir

run: create_img
	$(QEMU) = qemu-system-i386 -cdrom myos.iso -monitor stdio
