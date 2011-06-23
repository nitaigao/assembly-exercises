section .data

	BOTTLES			equ 100

section .bss
	
	VERSELEN 	equ 	0
	VERSE 		resb 	256
	

section .text

        global _start

_start:
        nop
        
        mov 	eax, BOTTLES
		dec 	eax
		
loop:	mov 	ebx, 0Ah 			; we will divide by 10
		mov 	edx, 0				; reset the carry register
		div 	ebx					; do the division
		
		add 	edx, 30h			;take the result and add 48 to it (giving the ascii code)	
		
		mov 	[VERSE+esi], edx	; set the buffer offset to the ascii value
		inc		esi					; increment the offset
		
		cmp		eax, 0
		je		print
		jmp loop
		
print:		
		mov eax, 0Ah
		mov [VERSE+esi], eax
		inc esi
		mov eax, 4
		mov ebx, 1
		mov ecx, VERSE
		mov edx, esi
		int 80h

        mov eax, 1
        mov ebx, 0
        int 80H
