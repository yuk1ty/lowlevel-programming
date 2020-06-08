section .data
codes:
    db '0123456789ABCDEF'

section .text
global _start
_start:
    mov rax, 0x112233445566778899

    mov rdi, 1
    mov rdx, 1
    mov rcx, 64
.loop:
    push rax
    sub rcx, 4
    sar rax, cl
    and rax, 0xf

    lea rsi, [codes + rax]
    mov rax, 1

    push rcx
    syscall ;; sys_write??
    pop rcx

    pop rax
    test rcx, rcx ;; if rcx = 1 then 1 else 0
    jnz .loop

    mov rax, 60 ;; sys_exit
    xor rdi, rdi
    syscall