AS = x86_64-elf-as
LD = x86_64-elf-ld
CC = x86_64-elf-gcc
QEMU = qemu-system-i386

%.o: %.S
	$(AS) --32 -march=i386 -o $@ $*.S

%.o: %.c
	$(CC) -m32 -nostdlib -ffreestanding -c -o $@ $*.c

myos.bin: boot.o kernel.o Makefile
	$(LD) -T myos.ld -m elf_i386 boot.o kernel.o

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
	$(QEMU) -cdrom myos.iso -monitor stdio
