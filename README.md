# lowlevel-programming

# 実行とか

```
docker build -t lowlevel-programming:latest .
```

```
docker container run -it lowlevel-programming:latest
```

したあと、bash が起動しているので、

```
$ nasm -g -f elf64 hello_proper_exit.asm -o hello.o
```

して、

```
$ ld hello.o -o hello
```

したあとに（ld はリンカー）、

```
$ ./hello
```

で実行できる。
