CC=gcc
CFLAGS=-m64 -Wall

all:	main.o func.o
		$(CC) $(CFLAGS) main.o func.o -o main

main.o:	main.c
		$(CC) $(CFLAGS) -c main.c -o main.o

func.o:	func.asm
		nasm -f elf64 func.asm

clean:
		rm -f *.o
