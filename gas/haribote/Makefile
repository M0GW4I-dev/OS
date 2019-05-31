boot.bin: boot.s Makefile
	i686-elf-as -o boot.o boot.s
	i686-elf-ld --oformat binary -o boot.bin -e init -Ttext 0x7c00 boot.o

run: boot.bin
	qemu-system-x86_64 -drive format=raw,file=boot.bin
