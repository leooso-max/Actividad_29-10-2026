section .text
    global string_len

string_len:
    push ebp
    mov ebp, esp
    push esi
    sub esp, 4
    mov dword [ebp-8], 0 ; contador = 0

.start:
    mov esi, [ebp+8] ; recargar la base de la cadena
    add esi, [ebp-8] ; esi = base + contador
    cmp byte [esi], 0
    je .end
    inc dword [ebp-8]
    jmp .start

.end:
    mov eax, [ebp-8]
    add esp, 4
    pop esi
    pop ebp
    ret
