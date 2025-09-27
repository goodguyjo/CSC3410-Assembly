BITS 32

SECTION .bss
    two_char_string resb 3

SECTION .data
    msgPrompt DB "Enter two characters: ", 0xa
    lenPrompt equ $ - msgPrompt

    msgSwapped DB "The answer is: ", 0xa
    lenSwapped equ $ - msgSwapped

SECTION .text
    global _start

_start:
    ; Prompt for the 2 characters
    mov eax, 4
    mov ebx, 1
    mov ecx, msgPrompt
    mov edx, lenPrompt
    int 0x80

    ; Read in string using stdin
    mov eax, 3
    mov ebx, 0
    mov ecx, two_char_string
    mov edx, 3              ; read 2 char + new line
    int 0x80

    ; Swap the 2 chars
    mov al, [two_char_string]
    mov bl, [two_char_string + 1]
    mov [two_char_string], bl
    mov [two_char_string + 1], al

    ; Make sure newline is at the end
    mov byte [two_char_string + 2], 0xa

    ; Print answer message
    mov eax, 4
    mov ebx, 1
    mov ecx, msgSwapped
    mov edx, lenSwapped
    int 0x80

    ; Print swapped string
    mov eax, 4
    mov ebx, 1
    mov ecx, two_char_string
    mov edx, 3
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80