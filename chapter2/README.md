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

# 演習問題

## Q11: xor rdi, rdi とは何をする命令か？

同じレジスタに対して XOR 命令をかけるとゼロになるというテクニックがあり、それをやっている。rdi レジスタをゼロクリアしている。

## Q12: このプログラムのリターンコードは何だろう？

0

## Q13: exit システムコールの第 1 引数は？

ステータス？？int で入れる。

## Q15: sar と shr の違いは？

sar は算術シフトで右に 1 シフト、shr は論理シフトで右に 1 シフトと呼ばれる。左シフトなら、sal, shl が同様の関係性にある。

算術シフトの場合、たとえば右に 1 シフトする演算だと

```
10110101
>>>>>>>>
11011010 -> 1
```

論理シフトの場合、

```
10110101
>>>>>>>>
01011010 -> 1
```

最上位ビットからすべてのビットを右にシフトするのが算術シフト、最上位ビットはそのままに右にシフトするのが論理シフト。なぜ 2 つにわかれているかというと、符号付き整数を右に論理シフトする際に符号まで変わってしまうから。算術シフトであれば、符号を保ったままシフト演算をできる。高レベル言語では算術シフトをだいたいサポートしているらしい。

## Q16: 数を 10 進数以外の方法で書くには？

ここに書いてある →https://www.nasm.us/doc/nasmdoc3.html

```
mov     ax,200          ; decimal
mov     ax,0200         ; still decimal
mov     ax,0200d        ; explicitly decimal
mov     ax,0d200        ; also decimal
mov     ax,0c8h         ; hex
mov     ax,$0c8         ; hex again: the 0 is required
mov     ax,0xc8         ; hex yet again
mov     ax,0hc8         ; still hex
mov     ax,310q         ; octal
mov     ax,310o         ; octal again
mov     ax,0o310        ; octal yet again
mov     ax,0q310        ; octal yet again
mov     ax,11001000b    ; binary
mov     ax,1100_1000b   ; same binary constant
mov     ax,1100_1000y   ; same binary constant once more
mov     ax,0b1100_1000  ; same binary constant yet again
mov     ax,0y1100_1000  ; same binary constant yet again
```
