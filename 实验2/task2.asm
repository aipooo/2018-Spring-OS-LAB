org 07C00H 					;BIOS将把引导扇区加载到0:7C00h处;并开始执行

Start:
	mov ax, cs    			;置其他段寄存器值与CS相同
	mov ds, ax    			;数据段ds
	mov bp, Message 		;BP=当前串的偏移地址
	mov ax, ds 				;ES:BP=串基地址:串偏移地址=串地址
	mov es, ax 				;置ES=DS
	mov cx, MessageLength 	;CX=串长度 
	mov ax, 01301H 			;AH=13h(功能号;显示字符串);AL=01h(光标置于串尾)
	mov bx, 001FH 			;页号为0(BH=0);蓝底白字高亮无闪烁(BL=1Fh)
	mov dx, 0				;行号dh=0;列号dl=0
	int 10H 				;10h号中断
	mov ah,0				;从键盘读入字符到ah	
	int 16H					;16h号中断
	mov ah, 0EH	
	mov bl, 0
	int 10H					;10h号中断
	
cmp al, '1'
je LoadnFirst
cmp al, '2'
je LoadnSecond
cmp al, '3'
je LoadnThird
cmp al, '4'
je LoadnFourth



LoadnFirst:
	;读取扇区内容至ES:BX处
	mov ax, cs        		;段地址
	mov es, ax        		;ES=段地址
	mov bx, 7E00H 			;BX=偏移地址
	mov ah, 02H         	;功能号02H;读扇区
	mov al, 01H         	;AL=扇区数
	mov ch, 00H         	;CH=柱面号;起始编号为0
	mov cl, 02H         	;CL=起始扇区号;起始编号为1
	mov dh, 00H         	;DH=磁头号;起始编号为0
	mov dl, 00H        		;DL=驱动器号;这里是软盘
	int 13H 				;调用读磁盘BIOS的13h功能
	;引导扇区程序已加载到指定内存区域中
	jmp 7E00H
	
LoadnSecond:
	;读取扇区内容至ES:BX处
	mov ax, cs        		;段地址
	mov es, ax        		;ES=段地址
	mov bx, 8000H 			;BX=偏移地址
	mov ah, 02H         	;功能号02H;读扇区
	mov al, 01H         	;AL=扇区数
	mov ch, 00H         	;CH=柱面号;起始编号为0
	mov cl, 03H         	;CL=起始扇区号;起始编号为1
	mov dh, 00H         	;DH=磁头号;起始编号为0
	mov dl, 00H        		;DL=驱动器号;这里是软盘
	int 13H 				;调用读磁盘BIOS的13h功能
	;引导扇区程序已加载到指定内存区域中
	jmp 8000H

LoadnThird:
	;读取扇区内容至ES:BX处
	mov ax, cs        		;段地址
	mov es, ax        		;ES=段地址
	mov bx, 8200H 			;BX=偏移地址
	mov ah, 02H         	;功能号02H;读扇区
	mov al, 01H         	;AL=扇区数
	mov ch, 00H         	;CH=柱面号;起始编号为0
	mov cl, 04H         	;CL=起始扇区号;起始编号为1
	mov dh, 00H         	;DH=磁头号;起始编号为0
	mov dl, 00H        		;DL=驱动器号;这里是软盘
	int 13H 				;调用读磁盘BIOS的13h功能
	;引导扇区程序已加载到指定内存区域中
	jmp 8200H

LoadnFourth:
	;读取扇区内容至ES:BX处
	mov ax, cs        		;段地址
	mov es, ax        		;ES=段地址
	mov bx, 8400H 			;BX=偏移地址
	mov ah, 02H         	;功能号02H;读扇区
	mov al, 01H         	;AL=扇区数
	mov ch, 00H         	;CH=柱面号;起始编号为0
	mov cl, 05H         	;CL=起始扇区号;起始编号为1
	mov dh, 00H         	;DH=磁头号;起始编号为0
	mov dl, 00H        		;DL=驱动器号;这里是软盘
	int 13H 				;调用读磁盘BIOS的13h功能
	;引导扇区程序已加载到指定内存区域中
	jmp 8400H		

AfterRun:
   jmp $           			;无限循环	
	
Message:
    db '17341178 ', 0DH, 0AH
    db 'XueWeihao'
	MessageLength equ ($-Message)
	times 510-($-$$) db 0 	;填充剩下的空间;使生成的二进制代码恰好为512字节
	dw 0xaa55 				;结束标志
		
;Proj1
delay1 equ 10000
ddelay1 equ 800

start1:
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
	jmp 7c00H
	
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

datadef1:
	x1 dw 3  ;15
	y1 dw 3
	col1 dw 3
	char1 db ' '
	count1 dw delay1
	dcount1 dw ddelay1
	times 510+512-($-$$) db 0 	;填充剩下的空间;使生成的二进制代码恰好为512字节
	dw 0xaa55 						;结束标志

	
	
;project2	
Dn_Rt equ 1         		;D-Down	;1右下
Up_Rt equ 2         		;U-Up	;2右上
Up_Lt equ 3         		;R-right;3左上
Dn_Lt equ 4         		;L-Left	;4左下
delay2 equ 10000 			;计时器延迟计数;用于控制画框的速度
ddelay2 equ 800	 			;计时器延迟计数;用于控制画框的速度

start2:
	mov ax, cs
	mov ds, ax 				;DS=CS
	mov es, ax 				;ES=CS
	mov ax, 0B800H 			;文本窗口显存起始地址
	mov gs,	ax 				;全局段寄存器GS=B800H

loop2:
	dec word[count2] 		;递减计数变量
	jnz loop2 				;大于0则跳转至loop2
	mov word[count2], delay2
	dec word[dcount2] 		;递减计数变量
	jnz loop2
	mov word[count2], delay2
	mov word[dcount2], ddelay2
	;下面这段指令确定了字符最开始的运动方向
    mov al, 1
    cmp al, byte[rdul]
	jz DnRt
	mov al, 2
	cmp al, byte[rdul]
	jz UpRt
	mov al, 3
    cmp al, byte[rdul]
	jz UpLt
    mov al, 4
    cmp al, byte[rdul]
	jz DnLt

;向右下方运动
DnRt:						
	inc word[x]				;行加1
	inc word[y]				;列加1
	mov bx, word[x]			;BX=当前行号
	mov ax, 12				;最大行号=12-1=11
	sub ax, bx				;最大行号-当前行号
	jz dr2ur				;如果达到最大行号;则跳转至dr2ur
	mov bx, word[y]			;BX=当前列号
	mov ax, 80				;最大列号=80-1=79
	sub ax, bx				;最大列号-当前列号
	jz dr2dl				;如果达到最大列号;则跳转至dr2dl
	jmp show2				;显示下一时刻字符位置	
dr2ur:
	cmp word[y], 80
	jz 7c00H
    mov word[x],10			;下一时刻行号=10
    mov byte[rdul],Up_Rt	;向右上方运动
    jmp show2				;显示下一时刻字符位置
dr2dl:
	cmp word[x], 12
	jz 7c00H
    mov word[y],78			;下一时刻列号=78
    mov byte[rdul],Dn_Lt	;向左下方运动
    jmp show2				;显示下一时刻字符位置


;向右上方运动
UpRt:
	dec word[x]				;行减1
	inc word[y]				;列加1
	mov bx, word[y]			;BX=当前列号
	mov ax, 80				;最大列号=80-1=79
	sub ax, bx				;最大列号-当前列号
	jz ur2ul				;如果达到最大列号;则跳转至ur2ul
	mov bx, word[x]			;BX=当前行数
	mov ax, -1				;最小行号=-1+1=0
	sub ax, bx				;最小行号-当前行号	
	jz ur2dr				;如果达到最小行号;则跳转至ur2dr
	jmp show2				;显示下一时刻字符位置
ur2ul:
	cmp word[x], -1
	jz 7c00H
    mov word[y], 78			;下一时刻列号=78
    mov byte[rdul],Up_Lt	;向左上方运动
    jmp show2				;显示下一时刻字符位置
ur2dr:
	cmp word[y], 80
	jz 7c00H
    mov word[x],1			;下一时刻行号=1
    mov byte[rdul],Dn_Rt	;向右下方运动
    jmp show2				;显示下一时刻字符位置

;向左上方运动
UpLt:
	dec word[x]				;行减1
	dec word[y]				;列减1
	mov bx, word[x]			;BX=当前行号
	mov ax, -1				;最小行号=-1+1=0
	sub ax, bx				;最小行号-当前行号
	jz ul2dl				;如果达到最小行号;则跳转至ul2dl
	mov bx, word[y]			;BX=当前列号
	mov ax,	38				;最小列号=39+1=40
	sub ax, bx				;最小列号-当前列号
	jz ul2ur				;如果达到最小列号;则跳转至ul2ur
	jmp show2				;显示下一时刻字符位置
ul2dl:
	cmp word[y], 38
	jz 7c00H
    mov word[x], 1			;下一时刻行号=1
    mov byte[rdul], Dn_Lt	;向左下方运动
    jmp show2				;显示下一时刻字符位置
ul2ur:
	cmp word[x], -1
	jz 7c00H
    mov word[y], 41			;下一时刻列号=41
    mov byte[rdul], Up_Rt	;向右上方运动
    jmp show2				;显示下一时刻字符位置

;向左下方运动
DnLt:
	inc word[x]				;行加1
	dec word[y]				;列减1
	mov bx, word[y]			;BX=当前列号
	mov ax, 38				;最小列号=39+1=40		
	sub ax, bx				;当前列号-最小列号-当前列号
	jz dl2dr				;如果达到最小列号;则跳转至dl2dr
	mov bx, word[x]			;BX=当前行号
	mov ax, 12				;最大行号=12-1=11
	sub ax, bx				;最大列号-当前列号
	jz dl2ul				;如果达到最大列号;则跳转至dl2ul
	jmp show2				;显示下一时刻字符位置
dl2dr:
	cmp word[x], 12
	jz 7c00H
    mov word[y], 41			;下一时刻列号=41
    mov byte[rdul], Dn_Rt	;向右下方运动
    jmp show2				;显示下一时刻字符位置
dl2ul:
	cmp word[y], 38
	jz 7c00H
    mov word[x], 10			;下一时刻行号=10
    mov byte[rdul], Up_Lt	;向左上方运动
    jmp show2				;显示下一时刻字符位置


show2:
	mov ax, word[x]			
	mov bx, 80				
	mul bx					
	add ax, word[y]			;当前序号
	test ax, 0001H			;判断当前序号是否为奇数
	jz even					;如果不是奇数;则跳转至even执行
	mov bx, 2				
	mul bx					;每个字符占2Bytes
	mov bp, ax			
	mov ah, 0CFH 			;红底白字高亮闪烁
	jmp next2				;跳转至next;避免重复执行even
even:
	mov bx, 2				
	mul bx					;每个字符占2Bytes
	mov bp, ax				
	mov ah, 010H			;蓝底黑字无闪烁
next2:
	mov al, byte[char] 		;AL=显示字符值
	mov word[gs:bp], ax 	;显示字符的ASCII码值
	jmp loop2				;跳转至loop1

end:
	jmp $          			;停止画框，无限循环


datadef2:
	count2 dw delay2
	dcount2 dw ddelay2
	rdul db Dn_Rt    ; 向右下运动
	x dw 4
	y dw 38
	char db ' '
	times 510+512*2-($-$$) db 0 	;填充剩下的空间;使生成的二进制代码恰好为512字节
	dw 0xaa55 						;结束标志
	
	
;proj3
delay3 equ 10000 			;计时器延迟计数;用于控制画框的速度
ddelay3 equ 800	 			;计时器延迟计数;用于控制画框的速度

start3:
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
	jmp 7c00H

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
	
final: 
	jmp $
	
datadef3:
	x3 dw 15
	y3 dw 3
	col dw 3
	char3 db ' '
	count3 dw delay3
	dcount3 dw ddelay3
	times 510+512*3-($-$$) db 0 	;填充剩下的空间;使生成的二进制代码恰好为512字节
	dw 0xaa55 						;结束标志

;Proj4
delay4 equ 10000
ddelay4 equ 800

start4:
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
	jmp 7c00H
	
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

datadef4:
	x4 dw 22  
	y4 dw 39
	col4 dw 39
	char4 db ' '
	count4 dw delay4
	dcount4 dw ddelay4
	times 510+512*4-($-$$) db 0 	;填充剩下的空间;使生成的二进制代码恰好为512字节
	dw 0xaa55 						;结束标志
	



