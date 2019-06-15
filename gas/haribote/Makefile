ipl.o: boot.s Makefile
	i686-elf-as -o ipl.o boot.s

myos.img: ipl.o Makefile
	i686-elf-ld -nostdlib -T myos.ld --oformat binary -o myos.img ipl.o

run: myos.img
	qemu-system-i386 -drive format=raw,file=myos.img
