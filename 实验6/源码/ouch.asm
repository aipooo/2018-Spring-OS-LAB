OUCH:
    string db "OUCH!OUCH!"
	row dw 0
	col dw 0
	pos dw 0; 位置;1-5分别对应上中下左右
	rem dw 0


keyDo:
    push ax
    push bx
    push cx
    push dx
	push bp
	push es

	
	cmp word ptr[rem],1
	jnz farjmp
	mov word ptr[rem],0
	inc word ptr[pos]
	cmp word ptr[pos],6
	jnz change_pos
	mov word ptr[pos],1
change_pos:	
	cmp word ptr[pos],1
	je up_pos
	cmp word ptr[pos],2
	je mid_pos
	cmp word ptr[pos],3
	je down_pos
	cmp word ptr[pos],4
	je left_pos
	cmp word ptr[pos],5
	je right_pos
	
farjmp:	
	mov word ptr[rem],1
	jmp keyin	

up_pos:
	mov word ptr[row],4
	mov word ptr[col],35
	jmp printOUCH
mid_pos:
	mov word ptr[row],12
	mov word ptr[col],35
	jmp printOUCH	
down_pos:
	mov word ptr[row],20
	mov word ptr[col],35
	jmp printOUCH	
left_pos:
	mov word ptr[row],12
	mov word ptr[col],10
	jmp printOUCH	
right_pos:
	mov word ptr[row],12
	mov word ptr[col],60
	jmp printOUCH	


printOUCH:
    mov ah,13h 	                    ; 功能号
	mov al,0                 		; 光标放到串尾
	mov bl,0ah 	                    ; 亮绿
	mov bh,0 	                	; 第0页
	mov dh,byte ptr[row] 	        ; 第 c 行
	mov dl,byte ptr[col]  	        ; 第35列
	mov bp, offset string 	        ; BP=串地址
	mov cx,10  	                    ; 串长为 10
	int 10h 		                ; 调用10H号中断
 
keyin: 
	in al,60h
	mov al,20h					    ; AL = EOI
	out 20h,al						; 发送EOI到主8529A
	out 0A0h,al					    ; 发送EOI到从8529A
	pop es
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	iret							; 从中断返回