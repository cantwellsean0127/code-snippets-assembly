./bin/print-integers.exe: ./obj/print-integers.obj
	mkdir -p bin
	gcc ./obj/print-integers.obj -o ./bin/print-integers.exe -no-pie

./obj/print-integers.obj: ./src/print-integers.asm
	mkdir -p obj
	nasm ./src/print-integers.asm -o ./obj/print-integers.obj -f elf64