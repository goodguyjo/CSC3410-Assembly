BITS 32

SECTION .data
    msg1 db "Enter first digit: ", 0xA
    len1 equ $ - msg1
    msg2 db "Enter second digit: ", 0xA
    len2 equ $ - msg2
    msgAns db "The answer is: "
    lenAns equ $ - msgAns
    nl db 0xA

SECTION .bss
    num1 resb 2
    num2 resb 2
    result resb 1

SECTION .text
    global _start

_start:
    ; Prompt first number
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, len1
    int 0x80

    ; Read first number
    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 2
    int 0x80

    ; Convert first number and save in bl
    mov al, [num1]
    sub al, '0'
    mov bl, al        ; store first digit in bl

    ; Prompt second number
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 0x80

    ; Read second number
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 2
    int 0x80

    ; Convert second number
    mov al, [num2]
    sub al, '0'

    ; Add first number from bl
    add al, bl
    mov [result], al

    ; Print result message
    mov eax, 4
    mov ebx, 1
    mov ecx, msgAns
    mov edx, lenAns
    int 0x80

    ; Print result digit
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 1
    int 0x80

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, nl
    mov edx, 1
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80