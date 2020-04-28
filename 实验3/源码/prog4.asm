;Proj4
org 1400h
delay4 equ 10000
ddelay4 equ 800

start4:
	call clear
	mov ax, cs
	mov ds, ax 				;DS=CS
	mov es, ax 				;ES=CS
	mov ax, 0B800H 			;文本窗口显存起始地址
	mov gs,	ax 				;全局段寄存器GS=B800H
	call fun4
	add word[col4], 8
	call fun4
	add word[col4], 8
	call fun4
	add word[col4], 8
	call fun4
	add word[col4], 8
	call fun4
	add word[col4], 8
	call show4
	ret
	
fun4:
	part1:
		call show4
		dec word[x4]
		mov ax, word[x4]
		sub ax, 15
		jb part2
		jmp part1
	part2:
		call show4
		inc word[x4]
		inc word[y4]
		mov bx, word[y4]
		mov dx, word[col4]
		add dx, 8
		sub bx, dx
		jb part2
	ret
	

	
	
show4:
	dec word[count4] 		;递减计数变量
	jnz show4 				;大于0则跳转至show4
	mov word[count4], delay4
	dec word[dcount4] 		;递减计数变量
	jnz show4
	mov word[count4], delay4
	mov word[dcount4], ddelay4
	
	push dx
	mov ax, word[x4]			
	mov bx, 80				
	mul bx			
	add ax, word[y4]		;当前序号
	mov bx, 2				
	mul bx					;每个字符占2Bytes
	mov bp, ax			
	mov ah, 60H 			;红底白字高亮无闪烁
	mov al, byte[char4]		;AL=显示字符值;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov word[gs:bp], ax 	;显示字符的ASCII码值
	pop dx
	ret
	
clear:
	mov ax,0003H    		;清屏属性
    int 10H         		;调用中断
	ret             		;返回

datadef4:
	x4 dw 22  
	y4 dw 39
	col4 dw 39
	char4 db ' '
	count4 dw delay4
	dcount4 dw ddelay4
	times 510+512*4-($-$$) db 0 	;填充剩下的空间;使生成的二进制代码恰好为512字节
	dw 0xaa55 						;结束标志