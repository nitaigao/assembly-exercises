section .data
section .text

        global _start

_start:
        nop

        mov eax, 1
        mov ebx, 0
        int 80H

section .bss
