# Makefile for compiling x86 assembly files
# This makefile will build all .asm files in the current directory

# Define compiler and flags
ASM = nasm
ASM_FLAGS = -f elf32
LD = ld
LD_FLAGS = -m elf_i386

# Find all .asm files and derive target names (excluding .o files)
ASM_SOURCES = $(wildcard *.asm)
OBJ_FILES = $(ASM_SOURCES:.asm=.o)
EXECUTABLES = $(filter-out %.o, $(ASM_SOURCES:.asm=))

# Default target - build all executables
all: $(EXECUTABLES)

# Rule to build an executable from a .o file
%: %.o
	$(LD) $(LD_FLAGS) $< -o $@

# Rule to build a .o file from a .asm file
%.o: %.asm
	$(ASM) $(ASM_FLAGS) $< -o $@

# Clean up all object files and executables
clean:
	rm -f $(OBJ_FILES) $(EXECUTABLES)

# List all targets that can be built
list:
	@echo "Available targets:"
	@for target in $(EXECUTABLES); do \
		echo "  $$target"; \
	done

# Display help information
help:
	@echo "Makefile for compiling x86 assembly programs"
	@echo ""
	@echo "Usage:"
	@echo "  make all           - Build all programs"
	@echo "  make [program]     - Build specific program (without .asm extension)"
	@echo "  make clean         - Remove all object files and executables"
	@echo "  make list          - List all available targets"
	@echo ""
	@echo "Example: make hw     - Builds the hw program from hw.asm"

# Declare phony targets
.PHONY: all clean list help