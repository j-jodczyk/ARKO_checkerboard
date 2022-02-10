

section	.text
global  checkerboard24

checkerboard24:
    push	ebp
    mov	    ebp,    esp
    push    ebx                 ; callee saved register
    push    esi
    push    edi

    mov     edi,    [ebp+8]     ; move *img to edi
    ; calculate padding
    mov     edx,    [edi+18]    ; move img_width
    lea     edx,    [edx+edx*2]
    mov     ecx,    edx
    add     edx,    3
    and     edx,    0xFFFFFFFC
    sub     edx,    ecx         ; edx = padding
    push    edx

    mov     ah,     [ebp+12]    ; ah = sqr_ver
    mov     al,     ah          ; al = sqr_ver
    shl     al,     1           ; al = 2*sqr_ver

    mov     ebx,    [edi+22]    ; y = height

    mov     esi,    54          ; move index pointer to 1.px

    mov     edx,    [ebp+16]    ; move color1 to edx;
    mov     ecx,    [ebp+20]    ; move color2 to ecx;
    xor     ecx,    edx         ; ecx = xor(color1, color2)

y_loop:
    push    eax
    push    ebx
    mov     ebx,    [edi+18]    ; x = width
    mov     ah,     [ebp+12]    ; al = sqr_hor
x_loop:

    mov     [edi+esi], dx      ; set color
    bswap   edx
    mov     [edi+esi+2], dh
    bswap   edx

    add     esi,       3        ; index += 3
    dec     ah                  ; sqr_hor--
    jnz     skip_color_change
    mov     ah,        [ebp+12] ; al = sqr_hor
    xor     edx,       ecx      ; change color
skip_color_change:
    dec     ebx                 ; x--
    jnz     x_loop
    ; end of x_loop
zero_x_index:
    pop     ebx                 ; pop height
    pop     eax                 ; resotre vertical color couter
    pop     edx                 ; pop padding

    add     esi,    edx         ; index += padding
    push    edx                 ; push padding

    mov     edx,    [ebp+16]    ; move color1 to edx;

    dec     al                  ; sqr_ver--
    dec     ah

    jnz     skip_color_change2  ; if still in color1 sqr, dont change color
    test    al,     al          ; test zamiast cmp
    jnz     al_not_zero         ; if still in color2 sqr, jump al_not_zero
    mov     ah,     [ebp+12]    ; ah = sqr_ver
    mov     al,     ah          ; al = sqr_ver
    shl     al,     1           ; al = 2*sqr_ver
    jmp     skip_color_change2
al_not_zero:
    inc     ah
    xor     edx,    ecx         ; change color

skip_color_change2:
    dec     ebx                  ; y--
    jnz     y_loop
    ; end of y_loop

end:
    pop     edx
    pop     edi
    pop     esi
    pop     ebx
    pop     ebp
    ret

