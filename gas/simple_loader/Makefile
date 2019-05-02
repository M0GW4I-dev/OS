abc: a.s b.s c.s
	i686-elf-as -o a.o a.s
	i686-elf-as -o b.o b.s
	i686-elf-as -o c.o c.s
	i686-elf-gcc -nostdlib -ffreestanding -T abc.ld -o abc a.o b.o c.o
