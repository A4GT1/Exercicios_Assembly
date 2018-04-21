; Exercício 2
; Implementando a mensagem na tela com a chamada de função printf do C;
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

	push total     		     ; scanf("fmt", &endereço)
	push read_fmt     	     ; %d para segundos;
	call scanf        	     ; chama a função
	add esp, 8        	     ; volta o esp

						     ; Divídimos os segundos pela hora cheia ex: 7200s/3600 = 2hrs
	xor edx, edx             ; Como o dividendo é formado por EDX:EAX, EDX deve ser zerado para que tenhamos um resultado limpo
	mov eax, [total]         ; Colocamos o valor de total em eax
	mov ecx, 3600            ; A constante 3600 em ecx
	div ecx                  ; Divisão aqui, (Detalhe, DIV é para divisão sem sinal, para divisão sem sinal Utilizar IDIV)
							 ; Consultar a Intel CodeTable
	mov [hora], eax          ; O quociente é guardado automaticamente em eax, então devemos voltar seu valor em hora

							 ; Para gerar o numero em minutos precisamos da seguinte fórmula: (total - (horas*3600) / 60)
							 ; Repare que o total - (horas*3600) é a mesma coisa que o resto da divisão
							 ; para resolver só pegamos o resto e dividimos por 60 (minutos)
							 ; O resto da divisão sempre fica no edx
	mov [minutos], edx	     ; Aqui só utilizamos minutos como auxiliar para salvar o edx

	xor edx, edx             ; zeramos o edx, agora perdemos o valor salvo nele anteriormente
	mov eax, [minutos]       ; (Valor de edx)
	mov ecx, 60              ; Divisão agora em 60 minutos
	div ecx                  ; Divide

	mov [minutos], eax       ; Minutos agora é realmente correto, (recebeu o valor)

	mov [segundos], edx	     ; Aqui só utilizamos segundos como auxiliar e salvar o edx da divisão anterior (resto/60)
							 ; Só pode resultar nos segundos finais
	xor edx, edx             ; zeramos o edx novamente
	mov eax, [segundos]      ; (Valor do edx anterior)
	mov ecx, 60              ; Divisão agora em 60 segundos
	div ecx                  ; Divide

	mov [segundos], edx      ; Segundos agora é realmente correto

	push dword [segundos]	 ; Empilha para o printf de trás para frente, sempre o último elemento primeiro
	push dword [minutos]	 
	push dword [hora]	     
	push msg_convert
	call printf			     ; Imprime
	add esp, 16

	mov eax,1                ; Move eax para 1, (sys_exit)
	int 0x80                 ; Se somente estiver com o eax em 1, o sistema entende que é uma
		                     ; Tentativa de parar a execução do algoritmo

; Área para ariáveis não inicializadas (Aqui é o melhor lugar para se colocar constantes)
; Aqui é alocado o espaço na RAM e em FLASH/ROM da mesma, no mesmo tamanho
section .data

; Mensagem
msg db "Digite o numero em segundos para ser convertido em [hh/mm/ss]", 10, 0
msg_convert db "Convertendo segundos em [hh/mm/ss], resulta em: [%02d|%02d|%02d]", 10, 0

; Formato do scanf
read_fmt db "%d", 0

; Área para guardar variáveis não inicializadas, todos os valores colocados em .bss
; Recebem zero em sua composição, e são carregados em Memória, exemplo: "int valor = 0"
section .bss

total: resd 1 ; Reserva de 1 DW de (32 bits)
hora: resd 1 ; Horas
minutos: resd 1; Minutos
segundos: resd 1 ; Segundos