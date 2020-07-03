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

## Q26: 次に挙げる命令のうち、正しくないのはどれか。そして、その理由は？

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

## Q27: 呼び出し先退避レジスタを列挙せよ

r12, r13, r14, r15, rbx, rsp, rbp

## Q28: 呼び出し元退避レジスタを列挙せよ

rax, rcx, rdx, rdi, rsi, r8-r11

## Q29: rip レジスタの意味は？

64 ビット用のプログラムカウンタ。

## Q30: SF は何のフラグか。

SF (Sign Flag) 。演算結果が負のとき 1、それ以外のとき 0 になる。

## Q31: ZF は何のフラグか。

ZF (Zero Flag) 。演算結果がゼロのとき 1、それ以外のとき 0 になる。

## Q32: 次にあげる命令の効果を述べよ

- sar: 算術右シフト
- shr: 右シフト
- xor: 排他的論理和
- jmp: 目的のアドレスにジャンプする
- ja, jb, その他: 特定のジャンプ条件を満たす時に目的のアドレスにジャンプする。ja なら CF = 0 & ZF = 0 など。
- cmp: 比較命令
- mov: データを転送する
- inc, dec: +1, -1
- add: データを加算する
- imul, mul: データを乗算する。imul は符号付きかけ算。mul は符号なしかけ算。
- sub: データを減算する。
- idiv, div: データを除算する。idiv は符号付き除算。div は符号なし除算。
- call, ret: 指定したアドレスをコールする。ret で関数から復帰する。
- push, pop: スタックの push と pop

## Q33: ラベルとは何か

アドレスに特別に名前付けされている箇所で、そこに飛べる。アドレスはサイズを持たない。メモリセルに保存されないため。

## Q34: ある整数値が、ある範囲 (x, y) に含まれるかどうかを、どうやってチェックすればよいか。

cmp 命令を使って挟み込むとできる。たとえば、(0, 10) の範囲にある数値かどうかを判定したい場合には、

```asm
mov rax, 20
cmp rax, 10
; 別のラベルなり関数なりに飛ぶ
cmp rax, 0
; 別のラベルなり関数なりに飛ぶ
```

で可能である。

## Q35: ja/jb と jg/jl の違いは？

ja/jb は CF = 0 か CF = 1 かで、jg/jl は SF に関する比較をしてからジャンプする。ジャンプ条件のカテゴリが異なる。

## Q36: je と jz の違いは？

前に別の問題で回答済み。

## Q37: rax がゼロかどうかを、cmp コマンドを使わずにテストする方法は？

test rax, rax

## Q38: プログラムのリターンコードとは何か？

関数からの脱出

## Q39: ただ 1 つの命令で rax を 9 倍にする方法は？

```asm
lea rax, [rax+rax*8]
```

## Q40: ただ 2 つの命令で、rax に格納されている整数の絶対値を求めよ

下記を実行してラベルにジャンプしたあとには、rax は絶対値をもっているらしい…？

```asm
label:
    neg rax
    jl label
```

## Q41: リトルエンディアンとビッグエンディアンは、どう違うのか？

0x1122334455667788 を考えると

リトルエンディアン

- スタートアドレス: 0x88
- スタートアドレス+1: 0x77
  ...
- スタートアドレス+7: 0x11

ビッグエンディアン

- スタートアドレス: 0x11
- スタートアドレス+1: 0x22
  ...
- スタートアドレス+7: 0x88

## Q42: もっと複雑な種類のアドレッシングは？

## Q43: プログラムの実行は、どこからはじまる？

`_start` ラベル。

## Q44: rax 　の値が 0x1122334455667788 であるとき、push rax を実行した。[rsp+3] のアドレスにあるバイトデータの内容は？

rsp はまず、スタックのトップを示す。したがって、

- rsp+0: 0x88
- rsp+1: 0x77
- rsp+2: 0x66
- rsp+3: 0x55

といった感じで配置されている。リトルエンディアンのため。ビッグエンディアンの場合は 0x11 始まりになる。
