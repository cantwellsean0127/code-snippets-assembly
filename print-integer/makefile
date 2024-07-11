./bin/print-integers.exe: ./obj/main.obj ./obj/print-integer.obj
	mkdir -p bin
	gcc ./obj/main.obj ./obj/print-integer.obj -o ./bin/print-integers.exe -no-pie

./obj/main.obj: ./src/main.asm
	mkdir -p obj
	nasm ./src/main.asm -o ./obj/main.obj -f elf64 -g -F dwarf

./obj/print-integer.obj: ./src/print-integer.asm
	nasm ./src/print-integer.asm -o ./obj/print-integer.obj -f elf64 -g -F dwarf

clean:
	rm -f ./bin/*
	rm -f ./obj/*
