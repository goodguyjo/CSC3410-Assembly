BITS 32

SECTION .data
    prompt_msg DB "Please enter a string:", 10, 0
    pal_msg DB "It is a palindrome", 10, 0
    notpal_msg  DB "It is NOT a palindrome", 10, 0

SECTION .bss
    buf resb 1024          ; buffer for user input

SECTION .text
    global _start

_start:
main_loop:
    ; print the prompt
    mov eax, 4              ; SYS_WRITE
    mov ebx, 1              ; stdout
    mov ecx, prompt_msg
    mov edx, 23             ; length of message
    int 0x80

    ; read input into buf
    mov eax, 3              ; SYS_READ
    mov ebx, 0              ; stdin
    mov ecx, buf
    mov edx, 1024
    int 0x80

    ; eax = number of bytes read
    mov esi, eax            ; store count in esi
    cmp byte [buf], 10      ; check if first char is newline
    je exit_program         ; if so, quit

    dec esi                 ; exclude newline from count

    ; call is_palindrome(buf, len)
    push esi                ; push len
    push buf                ; push buffer address
    call is_palindrome
    add esp, 8              ; clean up stack

    cmp eax, 1
    je print_pal
    jmp print_not

print_pal:
    mov eax, 4
    mov ebx, 1
    mov ecx, pal_msg
    mov edx, 20
    int 0x80
    jmp main_loop

print_not:
    mov eax, 4
    mov ebx, 1
    mov ecx, notpal_msg
    mov edx, 23
    int 0x80
    jmp main_loop

exit_program:
    mov eax, 1              ; SYS_EXIT
    xor ebx, ebx
    int 0x80

is_palindrome:
    push ebp
    mov ebp, esp

    mov ebx, [ebp + 8]      ; buffer pointer
    mov ecx, [ebp + 12]     ; len

    mov esi, 0              ; i = 0
    dec ecx                 ; j = len - 1

loop:
    cmp esi, ecx
    jge palindrome         ; done checking -> palindrome

    mov al, [ebx + esi]     ; al = buf[i]
    mov dl, [ebx + ecx]     ; dl = buf[j]
    cmp al, dl
    jne not_palindrome     ; mismatch -> not palindrome

    inc esi
    dec ecx
    jmp loop

palindrome:
    mov eax, 1
    jmp done

not_palindrome:
    mov eax, 0

done:
    pop ebp
    ret