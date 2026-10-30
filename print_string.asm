section .text
    global print_string
    extern string_len

print_string:
    push ebp
    mov ebp, esp
    push ebx

    push dword [ebp+8] ; argumento para string_len
    call string_len
    add esp, 4 ; eax = longitud

    mov edx, eax ; edx = longitud
    mov eax, 4 ; sys_write
    mov ebx, 1 ; stdout
    mov ecx, [ebp+8] ; puntero a la cadena
    int 0x80

    pop ebx
    pop ebp
    ret
