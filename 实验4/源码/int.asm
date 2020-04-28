;中断设置
setINT:
	push ax
	push es
	
	xor ax,ax
	mov es,ax
	mov word ptr es:[51*4],offset int_33h		;33h
	mov ax, cs
	mov word ptr es:[51*4+2],ax

	xor ax,ax
	mov es,ax
	mov word ptr es:[52*4],offset int_34h		; 34h
	mov ax, cs
	mov word ptr es:[52*4+2],ax

	xor ax,ax
	mov es,ax
	mov word ptr es:[53*4],offset int_35h		; 35h
	mov ax, cs
	mov word ptr es:[53*4+2],ax

	xor ax,ax
	mov es,ax
	mov word ptr es:[54*4],offset int_36h		; 36h
	mov ax, cs
	mov word ptr es:[54*4+2],ax
	
	pop es
	pop ax
ret

;**************** *******************
;调用33h中断
public _run33
_run33 proc 
    push ax
    push bx
    push cx
    push dx
	push es

	call _cls

    int 33h
call DelaySome
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_run33 endp

;***********************************
; 调用34h中断
public _run34
_run34 proc 
    push ax
    push bx
    push cx
    push dx
	push es

	call _cls

    int 34h
  call DelaySome
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_run34 endp

;***********************************
; 调用35h中断
public _run35
_run35 proc 
    push ax
    push bx
    push cx
    push dx
	push es

	call _cls

    int 35h
call DelaySome
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_run35 endp

;***********************************
; 调用36h中断
public _run36
_run36 proc 
    push ax
    push bx
    push cx
    push dx
	push es

	call _cls

    int 36h
 call DelaySome
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_run36 endp



;*****************************************
int_33h:
    push ax
	push bx
	push cx
	push dx
	push bp

	mov ah,13h 	                ; 功能号
	mov al,0 	            	; 光标放到串尾
	mov bl,05h 	                ; 亮绿
	mov bh,0 		            ; 第0页
	mov dh,0 	                ; 第0行
	mov dl,0 	                ; 第0列
	mov bp,offset message33 	; BP=串地址
	mov cx,356 	                ; 串长4
	int 10h 		            ; 调用10H号中断

	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	mov al,33h					; AL = EOI
	out 33h,al					; 发送EOI到主8529A
	out 0A0h,al					; 发送EOI到从8529A
	iret						; 从中断返回

message33:
    db "  ************     ************",0ah,0dh
	db "  ************     ************",0ah,0dh
	db "           ***              ***",0ah,0dh
	db "           ***              ***",0ah,0dh
	db "  ************     ************",0ah,0dh
	db "  ************     ************",0ah,0dh
	db "           ***              ***",0ah,0dh
	db "           ***              ***",0ah,0dh
	db "  ************     ************",0ah,0dh
	db "  ************     ************",0ah,0dh
	db 0ah,0dh
    db "        This is INT 33H!",'$'

int_34h:
    push ax
	push bx
	push cx
	push dx
	push bp

	mov ah,13h 	                ; 功能号
	mov al,0             		; 光标放到串尾
	mov bl,0ch 	                ; 亮绿
	mov bh,0             		; 第0页
	mov dh,0 	                ; 第5行
	mov dl,40 	                ; 第44列
	mov bp,offset message34     ; BP=串地址
	mov cx,756 	                ; 串长
	int 10h 		            ; 调用10H号中断

	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	mov al,34h					; AL = EOI
	out 34h,al					; 发送EOI到主8529A
	out 0A0h,al					; 发送EOI到从8529A
	iret						; 从中断返回

message34:
    db "  ************     ***      ***",0ah,0dh
	db "                                        "
	db "  ************     ***      ***",0ah,0dh
	db "                                        "
	db "           ***     ***      ***",0ah,0dh
	db "                                        "
	db "           ***     ***      ***",0ah,0dh
	db "                                        "
	db "  ************     ************",0ah,0dh
	db "                                        "
	db "  ************     ************",0ah,0dh
	db "                                        "
	db "           ***              ***",0ah,0dh
	db "                                        "
	db "           ***              ***",0ah,0dh
	db "                                        "
	db "  ************              ***",0ah,0dh
	db "                                        "
	db "  ************              ***",0ah,0dh
	db 0ah,0dh
	db "                                        "
    db "        This is INT 34H!",'$'


int_35h:
    push ax
	push bx
	push cx
	push dx
	push bp

	mov ah,13h 	                 ; 功能号
	mov al,0 		             ; 光标放到串尾
	mov bl,0eh 	                 ; 黄色
	mov bh,0 	                 ; 第0页
	mov dh,13 	                 ; 第13行
	mov dl,0 	                 ; 第0列
	mov bp,offset message35 	 ; BP=串地址
	mov cx,356 	                 ; 串长
	int 10h 		             ; 调用10H号中断

	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	mov al,35h					; AL = EOI
	out 35h,al					; 发送EOI到主8529A
	out 0A0h,al					; 发送EOI到从8529A
	iret						; 从中断返回

message35:
    db "  ************     ************",0ah,0dh
	db "  ************     ************",0ah,0dh
	db "           ***     ***         ",0ah,0dh
	db "           ***     ***         ",0ah,0dh
	db "  ************     ************",0ah,0dh
	db "  ************     ************",0ah,0dh
	db "           ***              ***",0ah,0dh
	db "           ***              ***",0ah,0dh
	db "  ************     ************",0ah,0dh
	db "  ************     ************",0ah,0dh
	db 0ah,0dh
    db "        This is INT 35H!",'$'



int_36h:
    push ax
	push bx
	push cx
	push dx
	push bp

	mov ah,13h 	                ; 功能号
	mov al,01h 	             	; 光标放到串尾
	mov bl,09h 	                
	mov bh,0 	                ; 第0页
	mov dh,13 	                ; 第13行
	mov dl,40 	                ; 第40列
	mov bp,offset message36 	; BP=串地址
	mov cx,756 	                ; 串长
	int 10h 		            ; 调用10H号中断

	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	mov al,36h					; AL = EOI
	out 36h,al					; 发送EOI到主8529A
	out 0A0h,al					; 发送EOI到从8529A
	iret						; 从中断返回

message36:
    db "  ************     ************",0ah,0dh
	db "                                        "
	db "  ************     ************",0ah,0dh
	db "                                        "
	db "           ***     ***         ",0ah,0dh
	db "                                        "
	db "           ***     ***         ",0ah,0dh
	db "                                        "
	db "  ************     ************",0ah,0dh
	db "                                        "
	db "  ************     ************",0ah,0dh
	db "                                        "
	db "           ***     ***      ***",0ah,0dh
	db "                                        "
	db "           ***     ***      ***",0ah,0dh
	db "                                        "
	db "  ************     ************",0ah,0dh
	db "                                        "
	db "  ************     ************",0ah,0dh
	db 0ah,0dh
	db "                                        "
    db "        This is INT 36H!",'$'
	
	
DelaySome:                          ; 延迟一段时间
    mov cx,40000      
toDelay:
	push cx
	mov cx,40000
	looptime:loop looptime 
	pop cx
	loop toDelay
	ret	
	

