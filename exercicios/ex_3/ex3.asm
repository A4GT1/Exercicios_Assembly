; Exercício 3
; Fatorial em c usango chamada de sub-rotina;
; Criado por: Leonardo Pliskieviski
; Área de código
section .text

	global main
	extern printf            ; Como é uma biblíotéca externa, declaramos aqui e o gcc faz todo trabalho por fora
	extern scanf

main:
	
	push msg          		 ; Emplilhamos a mensagem na pilha
	call printf		 		 ; E chamamos o printf (printf("msg"))
	add esp,4        		 ; Quando utilizamos uma chamada externa, sobre qualquer função
					  		 ; Temos que levar em conta de que esta função utiliza registradores também
					 		 ; Como eax, ebx, edx, edi, efi, etc, mas muitas vezes
					 		 ; Estes registradores são sujos com lixo que esta função guardou,o que podem vir a frente
					 		 ; Atrapalhar o funcionamento do algoritmo
					 		 ; Para resolvermos isso, devemos resetar ao valor padrão,
					  		 ; Adicionamos 4 ao esp pois empilhamos a mensagem (2) + a chamada do printf (2)
					  		 ; Quando a pilha empilha estes dados, cresce para baixo, fazendo reservas como:
					  		 ; esp = topo -4 (bytes)
					  		 ; para retornarmos ao estado inicial devemos somar (4)

	push fatorial     		 ; scanf("fmt", &endereço)
	push read_fmt     	     ; %d para segundos;
	call scanf        	     ; chama a função
	add esp, 8        	     ; volta o esp

	mov ecx, [fatorial]      ; eax e ecx começam no mesmo valor, detalhe que vão iterando entre sí e eax sempre guarda
	mov eax, ecx             ; O resultado de mul

fatorial_de:                 ; Cai na função

	cmp ecx, 1				 ; Compara ecx com 1
	je final                 ; se for igual (je = jump if equal) já vai para o fim do algoritmo

	dec ecx                  ; para realizar a multiplicação, precisamos do valor antigo original * este valor - 1 (fatorial)
    mov     edx, ecx         ; Assim decrementamos ecx e movemos ele para edx
    mul     edx              ; multiplica, e o resultado vai (oculto) para eax

    call fatorial_de         ; chama a função novamente, agora com ecx - 1



final:

	push eax                 ; empilha o resultado (em eax)
	push msg_result     	 ; a mensagem
	call printf        	     ; chama a função
	add esp, 8        	     ; volta o esp

	mov eax,1                ; Move eax para 1, (sys_exit)
	int 0x80                 ; Se somente estiver com o eax em 1, o sistema entende que é uma
		                     ; Tentativa de parar a execução do algoritmo

; Área para ariáveis não inicializadas (Aqui é o melhor lugar para se colocar constantes)
; Aqui é alocado o espaço na RAM e em FLASH/ROM da mesma, no mesmo tamanho
section .data

; Mensagem
msg db "Digite o numero para calcular seu fatorial", 10, 0
msg_result db "O resultado é de: %d", 10, 0

; Formato do scanf
read_fmt db "%d", 0

; Área para guardar variáveis não inicializadas, todos os valores colocados em .bss
; Recebem zero em sua composição, e são carregados em Memória, exemplo: "int valor = 0"
section .bss

fatorial: resd 1 ; Reserva de 1 DW de (32 bits)
