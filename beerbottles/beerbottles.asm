section .data

  BOTTLES     equ 100
  
  VERSE1A      db " bottles of beer on the wall, "
  VERSE1ALEN   equ $-VERSE1A
  
  VERSE1B      db " bottles of beer.", 10
  VERSE1BLEN   equ $-VERSE1B
  
  VERSE2A       db "Take one down and pass it around, "
  VERSE2ALEN    equ $-VERSE2A

  VERSE2B       db " bottles of beer on the wall.", 10
  VERSE2BLEN    equ $-VERSE2B

section .bss
  
  VERSELEN   equ   0
  VERSE     resb   256
  
  REVERSEBUFF resb 256
  

section .text

  global _start
  
_syscall:		
  int	0x80		;system call
  ret
  
; convert a number to a character array
  
_tostring:
  mov   esi, 0            ; reset esi to hold the length of the char array
_tostringloop:
  mov   ebx, 0Ah          ; we will divide by 10
  mov   edx, 0            ; reset the carry register
  div   ebx               ; do the division

  add   edx, 30h          ; take the result and add 48 to it (giving the ascii code) 

  mov   [VERSE+esi], edx  ; set the buffer offset to the ascii value
  inc   esi               ; increment the offset

  cmp   eax, 0            ; see if there are any more numbers to process
  jne   _tostringloop     ; if yes then loop
    
  ; reverse the string
      
  mov   ecx, 0            ; set the loop count to 0  
  mov   edx, esi          ; set the string length
  dec   edx               ; decrement the topmost half to a usable index

_loopreverse:


  mov   edi, [VERSE+ecx]  ; temp store the value on side a   
  mov   eax, [VERSE+edx]  ; temp store the value on side b
  mov   [VERSE+ecx], eax  ; set a to b
  mov   [VERSE+edx], edi  ; set b to a
    
  inc   ecx               ; increment the bottom half to a new index
  
  cmp   ecx, edx
  jne    _finishreverse
  
  dec   edx               ; decrement to topmost half to a new index
  
  mov   eax,  edx         ; take the topmostindex
  mov   ebx,  02h         ; set the divisor to 2
  div   ebx               ; divide
  
  cmp   ecx, eax          ; compare half of the top index to the bottom index
  jl    _loopreverse      ; if less than the bottom half index then loop
  
_finishreverse:
  ret

_start:
  nop
        
  mov   eax, BOTTLES      ; copy the number of bottles for processing
    
  dec   eax               ; decremend the number of bottles

_printverse:
  push  eax               ; store the number of bottles for later processing
  call  _tostring         ; stringify the number of bottles
  
  ; print the number of bottles
  
  push  dword esi         ; push the string length
  push  dword VERSE       ; push the string to print  
  push  dword 1           ; set to stdout 
  mov   eax, 0x4          ; prime a sys_write call
  call  _syscall          ; call the os to perform the print
  pop   eax               ; cleanup the stack
  pop   eax
  pop   eax
  
  ; print the first part of the verse 1
  
  push  dword VERSE1ALEN  ; push the string length
  push  dword VERSE1A     ; push the string to print
  push  dword 1           ; set to stdout 
  mov   eax, 0x4          ; prime a sys_write call
  call  _syscall          ; call the os to perform the print
  pop   eax               ; cleanup the stack
  pop   eax
  pop   eax
  
  ; print the number of bottles
  
  push  dword esi         ; push the string length
  push  dword VERSE       ; push the string to print
  push  dword 1           ; set to stdout 
  mov   eax, 0x4          ; prime a sys_write call
  call  _syscall          ; call the os to perform the print
  pop   eax               ; cleanup the stack
  pop   eax
  pop   eax
  
  ; print the second part of the verse 1

  push  dword VERSE1BLEN  ; push the string length
  push  dword VERSE1B     ; push the string to print
  push  dword 1           ; set to stdout 
  mov   eax, 0x4          ; prime a sys_write call
  call  _syscall          ; call the os to perform the print
  pop   eax               ; cleanup the stack
  pop   eax
  pop   eax
  
  ; print the first part of the verse 2
  
  push  dword VERSE2ALEN  ; push the string length
  push  dword VERSE2A     ; push the string to print
  push  dword 1           ; set to stdout 
  mov   eax, 0x4          ; prime a sys_write call
  call  _syscall          ; call the os to perform the print
  pop   eax               ; cleanup the stack
  pop   eax
  pop   eax
  
  ; decrement the number of bottles for the last part of the verse
  
  pop   eax               ; retrieve the bottle count from the stack
  dec   eax               ; decrement the bottle count
  push  eax               ; store the bottle count again
  call  _tostring         ; stringify the bottle count
  
  ; print the number of bottles
  
  push  dword esi
  push  dword VERSE
  push  dword 1           ; set to stdout 
  mov   eax, 0x4          ; prime a sys_write call
  call  _syscall          ; call the os to perform the print
  pop   eax               ; cleanup the stack
  pop   eax
  pop   eax
  
  ; print the second part of the verse 2

  push  dword VERSE2BLEN  ; push the string length
  push  dword VERSE2B     ; push the string to print
  push  dword 1           ; set to stdout 
  mov   eax, 0x4          ; prime a sys_write call
  call  _syscall          ; call the os to perform the print
  pop   eax               ; cleanup the stack
  pop   eax
  pop   eax
  
  pop   eax
  
  cmp   eax, 0
  jne   _printverse
  
  
  push  dword 0
  mov   eax, 1
  call _syscall
