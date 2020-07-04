section .data
correct: dq -1
section .text

global _start
_start:
    mov rax, [0x400000-1]
    ; メモリのスタート地点-1バイトのアドレス=0x3ffffffにアクセスするが、ここは無効なのでセグフォ。
    mov rax, 60
    xor rdi, rdi
    syscall 