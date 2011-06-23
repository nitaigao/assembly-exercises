section .data

  BOTTLES      equ 100

section .bss
  
  VERSELEN   equ   0
  VERSE     resb   256
  

section .text

  global _start
  
_syscall:		
  int	0x80		;system call
  ret

_start:
  nop
        
  mov   eax, BOTTLES
  dec   eax
    
_loop:
  mov   ebx, 0Ah          ; we will divide by 10
  mov   edx, 0            ; reset the carry register
  div   ebx               ; do the division
  
  add   edx, 30h          ; take the result and add 48 to it (giving the ascii code) 
  
  mov   [VERSE+esi], edx  ; set the buffer offset to the ascii value
  inc   esi               ; increment the offset
  
  cmp   eax, 0            ; see if there are any more numbers to process
  je    _print            ; if no then print out the string
  jmp   _loop             ; if yes then loop
    
_print:    
  mov eax, 0Ah
  mov [VERSE+esi], eax
  inc esi
  
  push  dword esi
  push  dword VERSE
  push  dword 1
  mov   eax, 0x4
  
  call _syscall

  push  dword 0
  mov   eax, 1
  call _syscall
