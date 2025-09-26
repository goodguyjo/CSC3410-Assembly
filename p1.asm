BITS 32

SECTION .text
    global _start

_start:
    ; Prompt for 1st number
    mov eax, 4 ; sys_read
    mov ebx, 1 ; stdout
    mov ecx, msg1
    mov edx, len1
    int 0x80

    ; Read in 1st number
    mov eax, 3 ; sys_read
    mov ebx, 0 ; stdin
    mov ecx, num1
    mov edx, 2
    int 0x80

    ; Convert 1st read-in char to int and created somewhere to store it
    mov al, [num1]
    sub al, '0'
    mov bl, al

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

    ; Convert 2nd read-in char to int
    mov al, [num2]
    sub al, '0'

    ; adding numbers al = al + bl
    add al, bl

    ; Convert sum to ASCII
    add al, '0'
    mov [sum], al

    ; Print result message
    mov eax, 4
    mov ebx, 1
    mov ecx, msgSum
    mov edx, lenSum
    int 0x80

    ; Print result digit
    mov eax, 4
    mov ebx, 1
    mov ecx, sum
    mov edx, 1
    int 0x80

    ; Print new line
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

    msgSum DB "The answer is: "
    lenSum equ $ - msgSum

    nl DB 0xa

SECTION .bss
    num1 resb 2     ; Store first int(1) and newline(1) 1+1=2
    num2 resb 2    ; Store second int and newline
    sum resb 1     ; Store sum char
