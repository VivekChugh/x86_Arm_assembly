# x86_Arm_assembly

# Files with *.s extension have **ARM assembly** code.

Compile: arm-linux-gnueabihf-gcc filename.s -o filename -static

Run(using QEmu emulator): qemu-arm filename

produce all binaries at once: make -f arm-Makefile 

Clear all binaries at once: make -f arm-Makefile clean

# Files with *.asm extension have **x86 assembly** code.

Compile(using nasm) and Link: nasm -f elf32 filename.asm -o filename.o  && ld -m elf_i386 filename.o -o

Run: ./filename 

produce all binaries at once: make -f x86-Makefile 

Clear all binaries at once: make -f x86-Makefile clean

