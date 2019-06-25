; Aluno: Lucas de Medeiros Nunes Fernandes
; Matrícula: 117110210

section .rodata
msg: db "Hello World", 10
len: equ $-msg
 
section .text
global _start

_start:
    mov edx,len
    mov ecx,msg
    mov ebx,1
    mov eax,4
    int 0x80
	 
    mov ebx,0
    mov eax,1
    int 0x80