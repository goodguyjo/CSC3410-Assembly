BITS 32

SECTION .data
    prompt_msg    db "Enter a string: ", 0
    pal_msg       db "It IS a palindrome", 10, 0
    notpal_msg    db "It is NOT a palindrome", 10, 0
    input_fmt     db "%s", 0

SECTION .bss
    buffer resb 1024

SECTION .text
    global addstr, is_palindromeASM, factstr, palindrome_check

    extern atoi
    extern printf
    extern scanf
    extern fact             ; C function: int fact(int n)
    extern is_palindromeC   ; C function: int is_palindromeC(char *s)

; ################################################################
; int addstr(char *a, char *b)
; - Calls atoi(a) and atoi(b), returns sum in EAX
; - preserves EBX
; ###############################################################
addstr:
    push ebp
    mov  ebp, esp
    push ebx            ; preserve callee-saved
    ; get 'a'
    mov  eax, [ebp + 8]    ; pointer to a
    push eax
    call atoi              ; convert to int
    add  esp, 4
    mov  ebx, eax          ; save atoi(a) in ebx (preserved)

    ; get 'b'
    mov  eax, [ebp + 12]   ; pointer to b
    push eax
    call atoi
    add  esp, 4             ; eax = atoi(b)

    add  eax, ebx          ; eax = atoi(b) + atoi(a)

    pop  ebx
    pop  ebp
    ret

; ###############################################################
; int is_palindromeASM(char *s)
; - Manual palindrome check using bytes; returns 1 or 0 in EAX
; - preserves EBX and ESI
; ###############################################################
is_palindromeASM:
    push ebp
    mov  ebp, esp
    push ebx
    push esi

    mov  esi, [ebp + 8]    ; esi = s

    ; compute length in ECX
    xor  ecx, ecx

len_loop:
    cmp  byte [esi + ecx], 0
    je   len_done
    inc  ecx
    jmp  len_loop

len_done:

    xor  ebx, ebx          ; left = 0
    mov  edx, ecx
    dec  edx               ; right = len - 1

check_loop:
    cmp  ebx, edx
    jge  is_pal
    mov  al, [esi + ebx]
    cmp  al, [esi + edx]
    jne  not_pal
    inc  ebx
    dec  edx
    jmp  check_loop

is_pal:
    mov  eax, 1
    jmp  cleanup

not_pal:
    mov  eax, 0

cleanup:
    pop  esi
    pop  ebx
    pop  ebp
    ret

; #####################################################################
; int factstr(char *s)
; - Calls atoi(s) then calls C func fact(n). Returns result in EAX.
; #####################################################################
factstr:
    push ebp
    mov  ebp, esp

    mov  eax, [ebp + 8]    ; pointer to s
    push eax
    call atoi
    add  esp, 4            ; eax = atoi(s)

    push eax               ; push n
    call fact              ; eax = fact(n)
    add  esp, 4

    pop  ebp
    ret

; #####################################################################
; void palindrome_check()
; - This function performs its own I/O:
;   prints prompt, scanf("%s", buffer), calls is_palindromeC(buffer)
;   prints the appropriate message
; - preserves EBX, ESI if used;
; #####################################################################
palindrome_check:
    push ebp
    mov  ebp, esp
    ; no callee-saved regs modified here

    ; printf(prompt_msg)
    push prompt_msg
    call printf
    add  esp, 4

    ; scanf("%s", buffer)
    push buffer
    push input_fmt
    call scanf
    add  esp, 8

    ; call is_palindromeC(buffer)
    push buffer
    call is_palindromeC
    add  esp, 4

    cmp  eax, 1
    je   print_pal

    ; print "not palindrome"
    push notpal_msg
    call printf
    add  esp, 4
    jmp  done

print_pal:
    push pal_msg
    call printf
    add  esp, 4

done:
    pop  ebp
    ret