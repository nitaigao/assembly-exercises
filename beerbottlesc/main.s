.align 4, 0x90

.globl _main

verse:
  .asciz "%d bottles of beer on the wall, %d bottles of beer! If one of those bottles fell off the wall there would be %d bottles of beer!\n"

_main:

pushq  %rbp
movq   %rsp, %rbp

movq	 $99, %rdi

_newVerse:

call _singVerse

movq	%rax, %rdi
movq	$0, %rcx

cmp  %rcx, %rax
jg	_newVerse

popq   %rbp
ret    

_singVerse:
pushq %rbp
mov   %rsp, %rbp

subq	$8, %rsp

movq	%rdi, %r9
movq  %r9, %rsi
movq	%r9, %rdx 

dec		%r9
movq	%r9, %rcx

pushq	%r9

leaq  verse(%rip), %rdi
movq  $0, %rax

callq _printf

popq	%rax

addq	$8, %rsp

popq  %rbp
ret