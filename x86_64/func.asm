

section	.text
        global  checkerboard24

checkerboard24:

    ; rdi *img
    ; rsi sqrsize
    ; rdx color1
    ; rcx color2
    push    r12
    push    r13
    push    r14

    ; calculate padding
    mov     rax,    [rdi+18]
    lea     eax,    [eax+eax*2]
    mov     r8d,    eax
    add     eax,    3
    and     eax,    0xFFFFFFFC
    sub     eax,    r8d         ; eax = padding

    mov     r9d,    [rdi+22]     ; y = height
    mov     r11d,    54          ; move index pointer to 1.px
    mov     r10,    rdx         ; copy of color1 in r10
    xor     rcx,    rdx         ; rcx = xor(c1, c2)

    mov     r13d,   esi
    mov     r14d,   r13d
    shl     r14d,   1

y_loop:
    mov     r8d,    [rdi+18]    ; x = width
    mov     r12d,    esi        ; r12d = sqr_hor
x_loop:
    mov     [rdi+r11],  dx      ; set color
    ror     edx, 16
    mov     [rdi+r11+2], dl
    rol     edx, 16

    add     r11d,        3        ; index += 3
    dec     r12d                  ; sqr_hor--
    jnz     skip_color_change
    mov     r12d,       esi      ; r9b = sqr_hor
    xor     edx,        ecx      ; change color
skip_color_change:
    dec     r8d                  ; x--
    jnz     x_loop
zero_x_index:
    add     r11d,    eax     ; add padding
    mov     edx,     r10d    ; edx = color1

    dec     r14d
    dec     r13d


    jnz     skip_color_change2
    test    r14d,     r14d  ; test zamiast cmp
    jnz     r13_not_zero
    mov     r13d,   esi
    mov     r14d,   r13d
    shl     r14d,   1
    jmp     skip_color_change2
r13_not_zero:
    inc     r13d
    xor     edx,    ecx
skip_color_change2:
    dec     r9d
    jnz     y_loop

end:
    pop     r14
    pop     r13
    pop     r12
    ret

