section .data

  BOTTLES     equ 100
  
  VERSE1A      db " bottles of beer on the wall, "
  VERSE1ALEN   equ $-VERSE1A
  
  VERSE1B      db " bottles of beer.", 10
  VERSE1BLEN   equ $-VERSE1B
  
  VERSE2A       db "Take one down and pass it around, "
  VERSE2ALEN    equ $-VERSE2A

section .bss
  
  VERSELEN   equ   0
  VERSE     resb   256
  
  REVERSEBUFF resb 256
  

section .text

  global _start
  
_syscall:		
  int	0x80		;system call
  ret
  
_tostring:
  mov   esi, 0
_loop:
  mov   ebx, 0Ah          ; we will divide by 10
  mov   edx, 0            ; reset the carry register
  div   ebx               ; do the division

  add   edx, 30h          ; take the result and add 48 to it (giving the ascii code) 

  mov   [VERSE+esi], edx  ; set the buffer offset to the ascii value
  inc   esi               ; increment the offset

  cmp   eax, 0            ; see if there are any more numbers to process
  jne   _loop             ; if yes then loop
  mov   ebx, 0
  mov   ecx, 0
  mov   edx, 0
    
  ret

_start:
  nop
        
  mov   eax, BOTTLES
  dec   eax
  push  eax
  call  _tostring
  
  push  dword esi
  push  dword VERSE
  push  dword 1
  mov   eax, 0x4
  call  _syscall
  pop   eax
  pop   eax
  pop   eax
  
  push  dword VERSE1ALEN
  push  dword VERSE1A
  push  dword 1
  mov   eax, 0x4
  call  _syscall
  pop   eax
  pop   eax
  pop   eax
  
  push  dword esi
  push  dword VERSE
  push  dword 1
  mov   eax, 0x4
  call  _syscall
  pop   eax
  pop   eax
  pop   eax

  push  dword VERSE1BLEN
  push  dword VERSE1B
  push  dword 1
  mov   eax, 0x4
  call  _syscall
  pop   eax
  pop   eax
  pop   eax
  
  push  dword VERSE2ALEN
  push  dword VERSE2A
  push  dword 1
  mov   eax, 0x4
  call  _syscall
  pop   eax
  pop   eax
  pop   eax
  
  pop   eax
  dec   eax
  call  _tostring
  
  push  dword esi
  push  dword VERSE
  push  dword 1
  mov   eax, 0x4
  call _syscall
  
  push  dword 0
  mov   eax, 1
  call _syscall
