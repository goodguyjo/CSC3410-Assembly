;;;_foobar: needs 3 arguments. The arguments are pushed onto the stack before calling this function.
;;; ;
;;; ; Examples:
;;; ;          push    110
;;; ;          push    45
;;; ;          push    67
;;; ;          call _foobar
;;; ;
;;; ;REGISTERS MODIFIED: EAX
;;; ;------------------------------------------------------
;;; ;------------------------------------------------------
_foobar:
    ; ebp must be preserved across calls. Since
    ; this function modifies it, it must be
    ; saved.
    ;
    push    ebp

    ; From now on, ebp points to the current stack
    ; frame of the function
    ;
    mov     ebp, esp

    ; Make space on the stack for local variables
    ;
    sub     esp, 16

    ; eax <-- a. eax += 2. then store eax in xx
    ;
    mov     eax, DWORD[ebp+8]
    add     eax, 2
    mov     DWORD[ebp-4], eax

    ; eax <-- b. eax += 3. then store eax in yy
    ;
    mov     eax, DWORD[ebp+12]
    add     eax, 3
    mov     DWORD[ebp-8], eax

    ; eax <-- c. eax += 4. then store eax in zz
    ;
    mov     eax, DWORD[ebp+16]
    add     eax, 4
    mov     DWORD[ebp-12], eax

    ; add xx + yy + zz and store it in sum
    ;
    mov     eax, DWORD[ebp-8]
    mov     edx, DWORD[ebp-4]
    lea     eax, [edx+eax]
    add     eax, DWORD[ebp-12]
    mov     DWORD[ebp-16], eax

    ; Compute final result into eax, which
    ; stays there until return
    ;
    mov     eax, DWORD[ebp-4]
    imul    eax, DWORD[ebp-8]
    imul    eax, DWORD[ebp-12]
    add     eax, DWORD[ebp-16]

    ; The leave instruction here is equivalent to:
    ;
    ;   mov esp, ebp
    ;   pop ebp
    ;
    ; Which cleans the allocated locals and restores
    ; ebp.
    ;
    leave
    ret

section .text
        global _start
_start:
     push    34
     push    59
     push    98
     call    _foobar

     mov     ebx, 0
     mov     eax, 1
     int     0x80
