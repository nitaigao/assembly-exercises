section .data

  ; You are LaRoza, aged 20 next year you will be 21, with user id 266234, the next user is 266235.

  ; User name can't begin with spaces, or have no characters in it. It can truncate strings over 20, if needed.
  ; Age has to be positive and not 0. It doesn't need a maximum, but you are free to make your program logical.
  ; User ID can't be negative or 0. The maximum I require is 999999.
  ; Typing "exit" should exit the program gracefully.
  ; The prompt should be logical.
  ; Most importantly, it must not crash, segfault, lockup, or enter an infinite loop no matter what is entered

  FIRSTQ db "Whats your name?: "
  FIRSTQLEN equ $-FIRSTQ

section .bss

  INPUTBUFFLEN  equ 1024
  INPUTBUFF:    resb INPUTBUFFLEN

section .text

  global _start

_start:

  nop

_askfirstq:

  ; Ask the first question

  mov   eax, 4            ; sys_write
  mov   ebx, 1            ; stdout
  mov   ecx, FIRSTQ       ; text
  mov   edx, FIRSTQLEN    ; length
  int   80h

  ; Get the response to the first question

  mov   eax, 3            ; sys_read
  mov   ebx, 0            ; stdin
  mov   ecx, INPUTBUFF    ; buffer to read in
  mov   edx, INPUTBUFFLEN ; length of the buffer to read
  int   80h
  
  cmp   eax, 1            ; just contains a character return            
  je    _askfirstq

  mov   esi, [INPUTBUFF]
  cmp   esi, 0A20h  ; the first character cant be a space
  je    _askfirstq
  
    


  mov   eax, 4
  mov   ebx, 1
  mov   ecx, INPUTBUFF
  mov   edx, esi
  int   80h

  mov   eax, 1
  mov   ebx, 0
  int   80h
