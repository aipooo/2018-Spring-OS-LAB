;Proj1
org 1400h
delay1 equ 10000
ddelay1 equ 800

start1:
	call clear      		;清屏
	mov ax, cs
	mov ds, ax 				;DS=CS
	mov es, ax 				;ES=CS
	mov ax, 0B800H 			;文本窗口显存起始地址
	mov gs,	ax 				;全局段寄存器GS=B800H
	call fun1
	add word[col1], 8
	call fun1
	add word[col1], 8
	call fun1
	add word[col1], 8
	call fun1
	ret
	
fun1:
	mov word[x1], 3
	p1:
		call show1
		inc word[y1]
		mov bx, word[y1]
		mov dx, word[col1]
		add dx, 8
		sub bx, dx
		jnb p2
		jmp p1
	p2:
		call show1
		inc word[x1]
		dec word[y1]
		mov ax, word[x1]
		sub ax, 11
		jnb p3
		jmp p2
	p3:
		call show1
		inc word[y1]
		mov bx, word[y1]
		mov dx, word[col1]
		add dx, 8
		sub bx, dx
		jna p3
	ret
		
	
show1:
	dec word[count1] 		;递减计数变量
	jnz show1 				;大于0则跳转至show1
	mov word[count1], delay1
	dec word[dcount1] 		;递减计数变量
	jnz show1
	mov word[count1], delay1
	mov word[dcount1], ddelay1
	
	push dx
	mov ax, word[x1]			
	mov bx, 80				
	mul bx			
	add ax, word[y1]		;当前序号
	mov bx, 2				
	mul bx					;每个字符占2Bytes
	mov bp, ax			
	mov ah, 10H 			;红底白字高亮无闪烁
	mov al, byte[char1]		;AL=显示字符值;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov word[gs:bp], ax 	;显示字符的ASCII码值
	pop dx
	ret
	
clear:
    mov ax,0003H    ; 清屏属性
    int 10H         ; 调用中断
	ret             ; 返回	

datadef1:
	x1 dw 3  ;15
	y1 dw 3
	col1 dw 3
	char1 db ' '
	count1 dw delay1
	dcount1 dw ddelay1
	times 510+512-($-$$) db 0 	;填充剩下的空间;使生成的二进制代码恰好为512字节
	dw 0xaa55 						;结束标志