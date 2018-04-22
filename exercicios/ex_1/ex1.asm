; Exercício 1
; Criado por: Leonardo Pliskieviski
; Área de código
section .text

	global main

main:
	mov edx, msg_size ; Tamanho da mensagem (incluindo o \n)
	mov ecx, msg      ; Mensagem em sí
	mov ebx, 1        ; Stdout
	mov eax, 4        ; Chama o método para imprimir do sistema
	int 0x80		  ; Interrompe, chama o kernel para ler o que foi feito

	mov eax,1         ; Move eax para 1, (sys_exit)
	int 0x80		  ; Se somente estiver com o eax em 1, o sistema entende que é uma,
		              ; Tentativa de parar a execução do algoritmo

; Área para ariáveis não inicializadas (Aqui é o melhor lugar para se colocar constantes)
; Aqui é alocado o espaço na RAM e em FLASH/ROM da mesma, no mesmo tamanho
section .data

; Mensagem
msg db "Leonardo Pliskieviski",10,0

; Função para pegar o tamanho da mensagem acima (equ), e guardar em msg_size
msg_size equ $ - msg

; Área para guardar variáveis não inicializadas, todos os valores colocados em .bss
; Recebem zero em sua composição, e são carregados em Memória, exemplo: "int valor = 0"
section .bss
