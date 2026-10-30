section .text
    global WC
    extern print_string

section .data
    msg_error1 db "Error: faltan argumentos", 10, 0
    msg_error2 db "Error: No se pudo abrir el archivo", 10, 0
    blanco     db " ", 0
    salto      db 10, 0

WC:
    push ebp
    mov ebp, esp
    sub esp, 24 ; Para las variables locales

    ; Variables locales
    mov dword [ebp-8], 0   
    mov dword [ebp-12], 0    
    mov dword [ebp-16], 0    
    mov dword [ebp-20], 0  

    cmp dword [ebp+4], 2
    jl .error1

    ; Abrir el archivo
    mov eax, 5                  
    mov ebx, [ebp+12]
    xor ecx, ecx
    xor edx, edx
    int 0x80

    mov [ebp-4], eax    
    test eax, eax
    js .error2

.ciclo_lectura:
    mov eax, 3                  
    mov ebx, [ebp-4]
    lea ecx, [ebp-24]
    mov edx, 1
    int 0x80
    cmp eax, 1
    jne .fin ; EOF

    inc dword [ebp-16]
    mov al, [ebp-24]

    cmp al, 10
    jne .espacio
    inc dword [ebp-8]

.espacio:
    cmp al, 32
    je  .es_espacio
    cmp al, 9
    jb  .no_espacio
    cmp al, 13
    ja  .no_espacio
.es_espacio:
    mov dword [ebp-20], 0 
    jmp .ciclo_lectura
.no_espacio:
    cmp dword [ebp-20], 0
    jne .ciclo_lectura
    inc dword [ebp-12]  
    mov dword [ebp-20], 1
    jmp .ciclo_lectura

.fin:
    ; fin del programa
    mov eax, 6               
    mov ebx, [ebp-4]
    int 0x80

    push dword [ebp-8]
    call imprimir_num
    add esp, 4
    push blanco
    call print_string
    add esp, 4

    push dword [ebp-12]
    call imprimir_num
    add esp, 4
    push blanco
    call print_string
    add esp, 4

    push dword [ebp-16]
    call imprimir_num
    add esp, 4
    push blanco
    call print_string
    add esp, 4

    push dword [ebp+12] ; nombre del archivo
    call print_string
    add esp, 4
    push salto
    call print_string
    add esp, 4

    xor ebx, ebx ; return 0
    jmp .salir

.error1:
    push msg_error1
    call print_string
    add esp, 4
    mov ebx, 1
    jmp .salir

.error2:
    push msg_error2
    call print_string
    add esp, 4
    mov ebx, 1

.salir:
    mov esp, ebp
    pop ebp
    mov eax, 1 ; exit(ebx)
    int 0x80

; imprime el entero sin signo que recibe en [ebp+8]
imprimir_num:
    push ebp
    mov  ebp, esp
    push edi
    mov  eax, [ebp+8]
    mov  ecx, 10
    xor  edi, edi
.d:
    xor edx, edx
    div ecx
    add dl, '0'
    push edx ; los digitos se guardan en la pila
    inc edi
    test eax, eax
    jnz .d
.p:
    mov eax, 4 ; write(1, esp, 1)
    mov ebx, 1
    mov ecx, esp
    mov edx, 1
    int 0x80
    add esp, 4
    dec edi
    jnz .p
    pop edi
    pop ebp
    ret
