.align 4, 0x90

.globl _main

hello:
  .asciz "Hello World!\n"

hellon:
  .asciz "%d + %d = %d\n"

_main:
pushq  %rbp
movq   %rsp, %rbp

movq   $1, %rdi
movq   $4096, %rsi

call _sum
call _printfit

popq   %rbp
ret    

_sum:
pushq %rbp
movq  %rsp, %rbp

addq %rdi, %rsi
mov  %rsi, %rax

popq  %rbp
ret

_printfit:
pushq %rbp
mov   %rsp, %rbp

movq  %rax, %rcx
movq  %rsi, %rdx
movq  %rdi, %rsi

leaq  hellon(%rip), %rdi

movq  $0, %rax

callq _printf

popq  %rbp
ret

_putsit:
pushq %rbp
movq  %rsp, %rbp

movq  %rax, %rbx

leaq  hello(%rip), %rax
movq  %rax, %rdi

movq  $0, %rax
mov   $0, %al

callq _puts

popq  %rbp
ret
