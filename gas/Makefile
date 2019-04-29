boot.bin:
	i686-elf-as -o boot.o boot.s
	i686-elf-ld -o boot.bin --oformat binary -e init boot.o
