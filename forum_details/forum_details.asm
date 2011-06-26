section .data

section .bss

  INPUTBUFFLEN  equ 1024
  INPUTBUFF:    resb INPUTBUFFLEN

section .text

  global _start

_start:

  nop

  mov   eax, 3            ; sys_read
  mov   ebx, 0            ; stdin
  mov   ecx, INPUTBUFF    ; buffer to read in
  mov   edx, INPUTBUFFLEN ; length of the buffer to read
  int   80h
  mov   esi, eax          ; copy the input length

  mov   eax, 4
  mov   ebx, 1
  mov   ecx, INPUTBUFF
  mov   edx, esi
  int   80h

  mov   eax, 1
  mov   ebx, 0
  int   80h
