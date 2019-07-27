AS = x86_64-elf-as
LD = x86_64-elf-ld
CC = x86_64-elf-gcc
QEMU = qemu-system-i386
BIN_DIR = ../bin
IMAGE_DIR = ../isodir/boot/grub
BOOT_DIR = $(IMAGE_DIR)/boot
GRUB_DIR = $(BOOT_DIR)/grub


%.o: %.S
	$(AS) --32 -march=i386 -o $(BIN_DIR)/$@ $*.S

%.o: %.c
	$(CC) -m32 -nostdlib -ffreestanding -c -o $(BIN_DIR)/$@ $*.c

myos.bin: boot.o kernel.o idt.o gdt.o Makefile
	$(LD) -o $(BIN_DIR)/myos.bin -T myos.ld -m elf_i386 $(BIN_DIR)/boot.o $(BIN_DIR)/kernel.o $(BIN_DIR)/idt.o $(BIN_DIR)/gdt.o

.PHONY: clean bin_test create_img run

clean:
	rm -f $(BIN_DIR)/*

bin_test: myos.bin
	./check.sh

create_img: bin_test
	mkdir -p $(GRUB_DIR)
	cp $(BIN_DIR)/myos.bin $(BOOT_DIR)/myos.bin
	cp grub.cfg $(GRUB_DIR)/grub.cfg
	i386-elf-grub-mkrescue -o $(BIN_DIR)/myos.iso $(IMAGE_DIR)

run: create_img
	$(QEMU) -cdrom $(BIN_DIR)/myos.iso -monitor stdio
