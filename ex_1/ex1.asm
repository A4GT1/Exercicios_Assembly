section .text

	global main

main:
	mov edx, msg_size ; Tamanho da mensagem
	mov ecx, msg      ; Mensagem em sí
	mov ebx, 1        ; STDOUT
	mov eax, 4        ; Call system print method
	int 0x80

	mov eax,1
	int 0x80

section .data

msg db "Leonardo Pliskieviski",10,0
msg_size equ $ - msg

section .bss
