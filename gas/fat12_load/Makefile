boot.bin: boot.s Makefile
	i686-elf-as -o boot.o boot.s
	i686-elf-ld --oformat binary -e init -Ttext 0x7c00 -o boot.bin boot.o

run: boot.bin
	qemu-system-x86_64 -drive format=raw,if=floppy,file=boot.bin
