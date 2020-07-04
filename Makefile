.PHONY: build
build:
	docker build -t lowlevel-programming:latest .

.PHONY: run
run:
	docker container run -it lowlevel-programming:latest

.PHONY: compile
compile:
	nasm -g -f elf64 ${FILE}.asm -o ${FILE}.o && ld ${FILE}.o -o ${FILE} && ./${FILE}