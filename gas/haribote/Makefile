ipl.o: boot.s Makefile
	i686-elf-as -o ipl.o boot.s

haribote.sys: haribote.s Makefile
	i686-elf-as -o haribote.sys haribote.s

myos.img: ipl.o myos.ld haribote.sys Makefile
	i686-elf-ld -nostdlib -T myos.ld --oformat binary -o myos.img ipl.o haribote.sys

run: myos.img
	qemu-system-i386 -drive format=raw,file=myos.img
