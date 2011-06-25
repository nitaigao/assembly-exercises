section .data

  BOTTLES     equ 100000
  
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
  
; reverse a character array
  
_reversestring:
  mov   ebx, 0            ; set the loop count to 0 
  mov   edx, esi          ; set the string length 
  
  dec 	edx
_loopreverse:
  mov   edi, [VERSE+ebx]  ; temp store the value on side a    
  mov   eax, [VERSE+edx]  ; temp store the value on side b
  mov   [VERSE+ebx], al  ; set a to b
	mov   [VERSE+edx], di  ; set b to a

	inc		ebx
	dec		edx
  
  cmp   edx, ebx           ; compare bottom index with half of top index
  jg    _loopreverse      ; if the top half is greater than the bettom then jump

_finishreverse:
  ret
  
; convert a number to a character array
  
_tostring:
  mov   esi, 0            ; reset esi to hold the length of the char array

_tostringloop:
  mov   ebx, 0Ah          ; we will divide by 10
  mov   edx, 0            ; reset the carry register
  div   ebx               ; do the division

  add   edx, 030h         ; take the result and add 48 to it (giving the ascii code) 

  mov   [VERSE+esi], edx  ; set the buffer offset to the ascii value
  inc   esi               ; increment the offset

  cmp   eax, 0h            ; see if there are any more numbers to process
  jne   _tostringloop     ; if yes then loop
  
  call _reversestring
  ret
    
_start:
  nop
        
  mov   eax, BOTTLES      ; copy the number of bottles for processing
  dec   eax               ; decremend the number of bottles

_printverse:
  push  eax               ; store the number of bottles for later processing
  call  _tostring         ; stringify the number of bottles
  
  ; print the number of bottles
  
  mov 	eax, 0x4  	      ; prep sys_write
  mov 	ebx, 1						; to stdout  
  mov 	ecx, VERSE        ; set to stdout 
  mov 	edx, esi          ; prime a sys_write call
  int	80h          				; call the os to perform the print
  
  ; print the first part of the verse 1
  
  mov 	eax, 0x4  	      		; prep sys_write
  mov 	ebx, 1								; to stdout  
  mov  	ecx, dword VERSE1A    ; push the string to print
  mov  	edx, dword VERSE1ALEN ; push the string length
  int	80h          						; call the os to perform the print
  
  
  ; print the number of bottles
  
  mov 	eax, 0x4  	      ; prep sys_write
  mov 	ebx, 1						; to stdout  
  mov  	ecx, dword VERSE  ; push the string to print
  mov  	edx, dword esi    ; push the string length
  int	80h          				; call the os to perform the print
  
  
  ; print the second part of the verse 1

  mov 	eax, 0x4  	      		; prep sys_write
  mov 	ebx, 1								; to stdout  
	mov  	ecx, dword VERSE1B    ; push the string to print
  mov  	edx, dword VERSE1BLEN ; push the string length
  int	80h          						; call the os to perform the print
  
  
  ; print the first part of the verse 2
  
  mov 	eax, 0x4  	      		; prep sys_write
  mov 	ebx, 1								; to stdout  
  mov  	ecx, dword VERSE2A    ; push the string to print
  mov  	edx, dword VERSE2ALEN ; push the string length
  int	80h          						; call the os to perform the print
  
  ; decrement the number of bottles for the last part of the verse
  
  pop   eax               ; retrieve the bottle count from the stack
  dec   eax               ; decrement the bottle count
  push  eax               ; store the bottle count again
  call  _tostring         ; stringify the bottle count
  
  ; print the number of bottles
  
  mov 	eax, 0x4  	      ; prep sys_write
  mov 	ebx, 1						; to stdout  
  mov  	ecx, dword VERSE
  mov  	edx, dword esi
  int	80h          				; call the os to perform the print
  
  ; print the second part of the verse 2

  mov 	eax, 0x4  	      		; prep sys_write
  mov 	ebx, 1								; to stdout  
  mov  	ecx, dword VERSE2B    ; push the string to print
  mov  	edx, dword VERSE2BLEN ; push the string length
	int 80h
	
  pop   eax
  
  cmp   eax, 0
  jne   _printverse
  
  
  mov   eax, 1
  mov		ebx, 0
	int 80h
