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

## Q17: je と jz の違いは？

`je` と `jz` は名前こそ違うものの中身は同じ命令。`zf` (zero flag) が 1 かどうかを見ている。opcode も同じ `74` を指している。[これ](https://hikalium.github.io/opv86/)見ると、まったく同じ opcode だとわかる。

## Q18 リストにある 4 個のコマンドを、それぞれ実行した結果、test の値はどうなるか？

```
section .data
test: dq -1

section .text

mov byte[test], 1	;1
mov word[test], 1	;2
mov dword[test], 1	;4
mov qword[test], 1	;8
```

これは、まずテストは次のように始まる。迷うことはないと思うが、`test` 命令ではないことに注意。

```
test: dq -1 ; 0xFFFFFFFFFFFFFFFF
            ; つまり、0x FF FF FF FF FF FF FF FF
```

下記のように動く。

```
mov byte[test], 1	; test = 0x FF FF FF FF FF FF FF FF
```

```
mov word[test], 1   ; test = 0x 00 FF FF FF FF FF FF FF
```

```
mov dword[test], 1  ; test = 0x 00 00 00 FF FF FF FF FF
```

```
mov qword[test], 1  ; test = 0x 00 00 00 00 00 00 00 00
```

## Q19 次に示すリストのバグを指摘せよ。

```
global _start

section .data

test_string: db "abcdef", 0

section .text

strlen:
.loop:
cmp byte [rdi+r13], 0
je .end
inc r13
jmp .loop
.end:
mov rax, r13
ret

_start:
mov rdi, test_string
call strlen
mov rdi, rax

mov rax, 60
syscall
```

r13 をゼロに初期化していないので、ランダムな値が入る可能性がある。また、.end の中で mov rax, r13 しているが、これはカウントが増えない。毎回保存する必要がある。したがって、直すならば次のようになるはず。

```
global _start

section .data

test_string: db "abcdef", 0

section .text

strlen:
push r13
xor r13, r13
.loop:
cmp byte [rdi+r13], 0
je .end
inc r13
jmp .loop
.end:
mov rax, r13
pop r13
ret

_start:
mov rdi, test_string
call strlen
mov rdi, rax

mov rax, 60
syscall

```

（演習問題は一度飛ばす）

## Q23: 次にあげるレジスタには、どういう関係があるか

```
rax, eax, ax, ah, al
```

共通する概念としては「アキュムレータ」。

rax: 64 ビット。
eax: 32 ビット。
ax: 16 ビット。
ah, al: 8 ビット。

## Q24: r9 レジスタの一部にアクセスするためにはどうすればよいか？

r9d, r9w, r9b。
d: the double word (32 ビット)
w: word (16 ビット)
b: byte (8 ビット)

## Q25: ハードウェアスタックの使い方は？利用できる命令は？

高レベル言語での関数コールを実装する際に利用できる。命令は、call, ret, push と pop。さらに、rsp レジスタを利用する。一般的なデータ構造におけるスタックと同じ。

## 次に挙げる命令のうち、正しくないのはどれか。そして、その理由は？

```
mov [rax], 0
cmp [rdx], bl
mov bh, bl
mov al, al
add bpl, 9
add [9], spl
mov r8d, r9d
mov r3b, al
mov r9w, r2d
mov rcx, [rax + rbx + rdx]
mov r9, [r9 + 8*rax]
mov [r8+r7+10], 6
mov [r8+r7+10], r6
```

- `mov [rax], 0`: どのサイズのものを書き込むのかわからない。直すなら、`mov dword[rax], 0` とかにするとよい。
- `mov r3b, al`, `mov r9w, r2d`: nasm は r8-r15 レジスタしか対応していない。
- `mov [r8+r7+10], 6`: サイズがわからない。
- `mov [r8+r7+10], r6`: nasm のサポート外。
