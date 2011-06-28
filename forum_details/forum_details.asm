section .data

  ; You are LaRoza, aged 20 next year you will be 21, with user id 266234, the next user is 266235.

  ; User name can't begin with spaces, or have no characters in it. It can truncate strings over 20, if needed.
  ; Age has to be positive and not 0. It doesn't need a maximum, but you are free to make your program logical.
  ; User ID can't be negative or 0. The maximum I require is 999999.
  ; Typing "exit" should exit the program gracefully.
  ; The prompt should be logical.
  ; Most importantly, it must not crash, segfault, lockup, or enter an infinite loop no matter what is entered

  NAMEQ db "Whats your name?: "
  NAMEQLEN equ $-NAMEQ

  AGEQ db "How old are you?: "
  AGEQLEN equ $-AGEQ

  FORUMIDQ db "What is your user id?: "
  FORUMIDQLEN equ $-FORUMIDQ

section .bss

  INPUTBUFFLEN  equ 1024
  INPUTBUFF:    resb INPUTBUFFLEN

section .text

  global _start

_start:

  nop

_asknameq:

  ; Ask the name question

  mov   eax, 4            ; sys_write
  mov   ebx, 1            ; stdout
  mov   ecx, NAMEQ        ; text
  mov   edx, NAMEQLEN     ; length
  int   80h

  ; Get the response to the name question

  mov   eax, 3            ; sys_read
  mov   ebx, 0            ; stdin
  mov   ecx, INPUTBUFF    ; buffer to read in
  mov   edx, INPUTBUFFLEN ; length of the buffer to read
  int   80h
  
  cmp   eax, 1            ; just contains a character return            
  je    _asknameq

  mov   esi, [INPUTBUFF]
  cmp   esi, 0A20h  ; the first character cant be a space
  je    _asknameq
  
_askageq:

  ; Ask the age question

  mov   eax, 4            ; sys_write
  mov   ebx, 1            ; stdout
  mov   ecx, AGEQ        ; text
  mov   edx, AGEQLEN      ; length
  int   80h
    
  ; Get the response to the age question

  mov   eax, 3            ; sys_read
  mov   ebx, 0            ; stdin
  mov   ecx, INPUTBUFF    ; buffer to read in
  mov   edx, INPUTBUFFLEN ; length of the buffer to read
  int   80h
  mov   esi, eax          ; store the length of the response

  cmp   esi, 1            ; just contains a character return            
  je    _askageq 


;   Check the string is a number

  xor   eax, eax          ; zero eax
  xor   ebx, ebx          ; zero ebx
  xor   ecx, ecx          ; zero ecx

; check of the very first character is 0 or less

  mov   ebx, [INPUTBUFF + ecx]  ; get the character
  sub   ebx, 030h               ; subtract 48 from it (makes it an integer value)

  cmp   bl, 01h                ; if its less than 1 then loop
  jl    _askageq

_anchkage:                ; check that the age is infact a number

  mov   ebx, [INPUTBUFF + ecx]  ; get the character
  sub   ebx, 030h               ; subtract 48 from it (makes it an integer value)

  cmp   bl, 09h                 ; if its greater than 9 then loop
  jg    _askageq 

  mov   edx, esi              ; copy the string length
  dec   edx                   ; decrement it, so we chop of the cr
  inc   ecx                   ; update the index of the character  
  cmp   ecx, edx              ; compare the index with the length of the string (minus the cr)
  jl    _anchkage             ; loop if we have more characters to process
  
_askforumq:

  ; Ask the user id question

  mov   eax, 4            ; sys_write
  mov   ebx, 1            ; stdout
  mov   ecx, FORUMIDQ         ; text
  mov   edx, FORUMIDQLEN      ; length
  int   80h
    
  ; Get the response to the user id question

  mov   eax, 3            ; sys_read
  mov   ebx, 0            ; stdin
  mov   ecx, INPUTBUFF    ; buffer to read in
  mov   edx, INPUTBUFFLEN ; length of the buffer to read
  int   80h
  mov   esi, eax          ; store the length of the response

  cmp   esi, 1            ; just contains a character return            
  je    _askforumq

;   Check the string is a number

  xor   eax, eax          ; zero eax
  xor   ebx, ebx          ; zero ebx
  xor   ecx, ecx          ; zero ecx

; check of the very first character is 0 or less

  mov   ebx, [INPUTBUFF + ecx]  ; get the character
  sub   ebx, 030h               ; subtract 48 from it (makes it an integer value)

  cmp   bl, 01h                ; if its less than 1 then loop
  jl    _askforumq

  mov   ebx, [INPUTBUFF + ecx]  ; get the character
  sub   ebx, 030h               ; subtract 48 from it (makes it an integer value)

  cmp   bl, 09h                 ; if its greater than 9 then loop
  jg    _askforumq


  mov   eax, 1
  mov   ebx, 0
  int   80h
