;proj3
org 7e00h
delay3 equ 10000 			;计时器延迟计数;用于控制画框的速度
ddelay3 equ 800	 			;计时器延迟计数;用于控制画框的速度

start3:
	call clear
	mov ax, cs
	mov ds, ax 				;DS=CS
	mov es, ax 				;ES=CS
	mov ax, 0B800H 			;文本窗口显存起始地址
	mov gs,	ax 				;全局段寄存器GS=B800H
	call fun3
	add word[col], 7
	add word[y3], 7
	call fun3
	add word[col], 7
	add word[y3], 7
	call fun3
	add word[col], 7
	add word[y3], 7
	call fun3
	add word[col], 7
	add word[y3], 7
	call fun3
	ret

fun3:
	o1:
		call show3
		inc word[x3]
		mov ax, word[x3]
		sub ax, 22
		jnb o2
		jmp o1
	o2:
		call show3
		inc word[y3]
		mov bx, word[y3]
		mov dx, word[col]
		add dx, 6
		sub bx, dx
		jnb o3
		jmp o2
	o3:
		call show3
		dec word[x3]
		mov bx, word[x3]
		sub bx, 15
		jb o4
		jmp o3
	o4:
		call show3
		dec word[y3]
		mov bx, word[y3]	
		sub bx, word[col]
		jnb o4
	ret
	
show3:
	dec word[count3] 		;递减计数变量
	jnz show3 				;大于0则跳转至show3
	mov word[count3], delay3
	dec word[dcount3] 		;递减计数变量
	jnz show3
	mov word[count3], delay3
	mov word[dcount3], ddelay3
	
	push dx
	mov ax, word[x3]			
	mov bx, 80				
	mul bx			
	add ax, word[y3]		;当前序号
	mov bx, 2				
	mul bx					;每个字符占2Bytes
	mov bp, ax			
	mov ah, 20H 			;红底白字高亮无闪烁
	mov al, byte[char3]		;AL=显示字符值;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov word[gs:bp], ax 	;显示字符的ASCII码值
	pop dx
	ret
	
clear:
	mov ax,0003H    		;清屏属性
    int 10H         		;调用中断
	ret             		;返回
	
datadef3:
	x3 dw 15
	y3 dw 3
	col dw 3
	char3 db ' '
	count3 dw delay3
	dcount3 dw ddelay3
	times 510+512*3-($-$$) db 0 	;填充剩下的空间;使生成的二进制代码恰好为512字节
	dw 0xaa55 						;结束标志