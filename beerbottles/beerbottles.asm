section .data

	VERSE				db	'99 bottles of beer on the wall, 99 bottles of beer.', 10, 'Take one down and pass it around, 98 bottles of beer on the wall.', 10
	VERSELENGTH			equ	$-VERSE

section .text

        global _start

_start:
        nop
        
        mov eax, 4 ;write system call
        mov ebx, 1 ;stdout 
        mov ecx, VERSE
        mov edx, VERSELENGTH
        int 80h

        mov eax, 1
        mov ebx, 0
        int 80H

section .bss
