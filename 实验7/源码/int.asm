;中断设置
setINT:
	push ax
	push es
	
		xor ax,ax
	mov es,ax
	mov word ptr es:[33*4],offset int_21h		;21h
	mov ax,cs 
	mov word ptr es:[33*4+2],ax

	
	xor ax,ax
	mov es,ax
	mov word ptr es:[51*4],offset int_33h		;33h
	mov ax, cs
	mov word ptr es:[51*4+2],ax

	xor ax,ax
	mov es,ax
	mov word ptr es:[52*4],offset int_34h		;34h
	mov ax, cs
	mov word ptr es:[52*4+2],ax

	xor ax,ax
	mov es,ax
	mov word ptr es:[53*4],offset int_35h		;35h
	mov ax, cs
	mov word ptr es:[53*4+2],ax

	xor ax,ax
	mov es,ax
	mov word ptr es:[54*4],offset int_36h		;36h
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


;***********************************
my_int_21h:
	push bx
	push cx
	push dx
	push bp

	cmp ah,0
	jnz cmp1
	call int_21h_0
    jmp end_21h
cmp1:
    cmp ah,1
	jnz cmp2
	call int_21h_1
    jmp end_21h
cmp2:
    cmp ah,2
	jnz cmp3
	call int_21h_2
    jmp end_21h
cmp3:
    cmp ah,3
	jnz cmp4
	call int_21h_3
    jmp end_21h
cmp4:
    cmp ah,4
	jnz cmp5
	call int_21h_4
    jmp end_21h
cmp5:
    cmp ah,5
	jnz cmp6
	call int_21h_5
    jmp end_21h
cmp6:
    cmp ah,6
	jnz cmp7
	call int_21h_6
    jmp end_21h
cmp7:
    cmp ah,7
	jnz cmp8
	call int_21h_7
    jmp end_21h
cmp8:
    cmp ah,8
	jnz end_21h
	call int_21h_8
    jmp end_21h

end_21h:
	pop bp
	pop dx
	pop cx
	pop bx

	iret						


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
	mov dh,5 	                ; 第0行
	mov dl,10 	                ; 第0列
	mov bp,offset message33 	; BP=串地址
	mov cx,16 	                ; 串长
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
    db "This is INT 33H!",'$'

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
	mov dh,5 	                ; 第5行
	mov dl,50 	                ; 第50列
	mov bp,offset message34     ; BP=串地址
	mov cx,16 	                ; 串长
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
    db "This is INT 34H!",'$'


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
	mov dh,18 	                 ; 第18行
	mov dl,10 	                 ; 第10列
	mov bp,offset message35 	 ; BP=串地址
	mov cx,16 	                 ; 串长
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
    db "This is INT 35H!",'$'



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
	mov dh,18 	                ; 第13行
	mov dl,50 	                ; 第40列
	mov bp,offset message36 	; BP=串地址
	mov cx,16 	                ; 串长
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
    db "This is INT 36H!",'$'
	
	
DelaySome:                          ; 延迟一段时间
    mov cx,40000      
toDelay:
	push cx
	mov cx,40000
	looptime:loop looptime 
	pop cx
	loop toDelay
	ret	

;*************** ********************
;*  21 号中断 0 号功能               *
;**************** *******************
; 屏幕中央显示 OUCH
int_21h_0:

    call _cls

	mov ah,13h 	                ; 功能号
	mov al,0 	             	; 光标放到串尾
	mov bl,0eh 	                
	mov bh,0 	                ; 第0页
	mov dh,12 	                ; 第18行
	mov dl,38 	                ; 第46列
	mov bp,offset MES_OUCH 	        ; BP=串地址
	mov cx,5 	                ; 串长为 28
	int 10h 		            ; 调用10H号中断

	ret

MES_OUCH:
    db "OUCH!"


;***********************************
;功能号1;小写转大写
int_21h_1:
    push dx						; 字符串首地址压栈
	call near ptr _to_upper     ; 调用 C 过程
	pop dx
	ret

;***********************************
;功能号2;大写转小写                    
int_21h_2:
    push dx						; 字符串首地址压栈                
	call near ptr _to_lower     ; 调用 C 过程
	pop dx
	ret

;***********************************
;功能号3;调用33h号中断
int_21h_3:
	call _run33     
	ret

;***********************************
;功能号4;调用34h号中断
int_21h_4:
	call _run34     
	ret
	
;***********************************
;功能号5;调用35h号中断
int_21h_5:
	call _run35     
	ret

;***********************************
;功能号6;调用36h号中断
int_21h_6:
	call _run36     
	ret

;***********************************
;功能号7;执行四个用户程序
int_21h_7:
	call near ptr _to_run_myprogram    ; 调用 C 过程
	ret		            ; 调用10H号中断

;***********************************
;功能号8;返回字符串长度
int_21h_8:

    call _cls

	mov ah,13h 	                ; 功能号
	mov al,0 	             	; 光标放到串尾
	mov bl,09h 	                ; 白底深蓝
	mov bh,0 	                ; 第0页
	mov dh,11 	                ; 第11行
	mov dl,25 	                ; 第25列
	mov bp,offset MES_data 	    ; BP=串地址
	mov cx,70 	                ; 串长为70
	int 10h 		            ; 调用10H号中断

	ret

MES_data:
    db "@Author    : XueWeihao",0dh,0ah
	db "                         "
	db "@StudentID : 17341178"

	
	
	

