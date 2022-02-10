CC=gcc
ASMBIN=nasm
ASM_SRC=func

all: assemble compile link

assemble: $(ASM_SRC).asm
	$(ASMBIN) -o $(ASM_SRC).o -f elf32 -g -l $(ASM_SRC).lst $(ASM_SRC).asm

compile: assemble main.c
	$(CC) -m32 -c -g -O0 -std=c99 main.c

link: compile
	$(CC) -m32 -g -o main main.o $(ASM_SRC).o

run:
	./main

clean:
	rm *.o
	rm main
	rm $(ASM_SRC).lst
