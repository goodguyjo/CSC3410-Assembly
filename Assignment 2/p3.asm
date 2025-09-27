BITS 32

SECTION .text
    global _start

_start:
    ; Prompt for 1st number
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, len1
    int 0x80

    ; Read in 1st number
    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 2
    int 0x80

    ; Prompt for 2nd number
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 0x80

    ; Read in 2nd number
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 2
    int 0x80

    ; Convert ASCII to int for num1
    mov al, [num1]
    sub al, '0'
    mov [num1], al

    ; Convert ASCII to int for num2
    mov bl, [num2]
    sub bl, '0'
    mov [num2], bl       ; overwrite stored num2 with integer

    ; Zero out AX
    xor ax, ax
    mov al, [num1]       ; load first number into AL

    ; Divide AX * [num2]
    idiv byte [num2]     ; AL has quotient, AH has remainder

    ; Save quotient
    mov bl, al
    add bl, '0'          ; convert back to ASCII
    mov [quotient], bl

    ; Save remainder
    mov bl, ah           ; move remainder to AL
    add bl, '0'
    mov [remainder], bl

    ; Print quotient message
    mov eax, 4
    mov ebx, 1
    mov ecx, msgQuotient
    mov edx, lenQuotient
    int 0x80

    ; Print quotient digit
    mov eax, 4
    mov ebx, 1
    mov ecx, quotient
    mov edx, 1
    int 0x80

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, nl
    mov edx, 1
    int 0x80

    ; Print remainder message
    mov eax, 4
    mov ebx, 1
    mov ecx, msgRemainder
    mov edx, lenRemainder
    int 0x80

    ; Print remainder digit
    mov eax, 4
    mov ebx, 1
    mov ecx, remainder
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

SECTION .data
    msg1 DB "Enter first digit: ", 0xa
    len1 equ $ - msg1

    msg2 DB "Enter second digit: ", 0xa
    len2 equ $ - msg2

    msgQuotient DB "The quotient is: "
    lenQuotient equ $ - msgQuotient

    msgRemainder DB "The remainder is: "
    lenRemainder equ $ - msgRemainder

nl DB 0xa

SECTION .bss
    num1 resb 2
    num2 resb 2
    quotient resb 1
    remainder resb 1