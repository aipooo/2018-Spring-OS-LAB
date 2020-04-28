org 07C00H 					;BIOS将把引导扇区加载到0:7C00h处;并开始执行

Start:
	mov ax, cs    			;置其他段寄存器值与CS相同
	mov ds, ax    			;数据段ds
	mov bp, Message 		;BP=当前串的偏移地址
	mov ax, ds 				;ES:BP=串基地址:串偏移地址=串地址
	mov es, ax 				;置ES=DS
	mov cx, MessageLength 	;CX=串长度 
	mov ax, 1301H 			;AH=13h(功能号;显示字符串);AL=01h(光标置于串尾)
	mov bx, 001FH 			;页号为0(BH=0);蓝底白字高亮无闪烁(BL=1Fh)
	mov dx, 0				;行号dh=0;列号dl=0
	int 10H 				;10h号中断
	
LoadtoM:
	;读取扇区内容至ES:BX处
	mov ax, 1000h        		;段地址
	mov es, ax        		;ES=段地址
	mov bx, 100h 			;BX=偏移地址
	mov ah, 02H         	;功能号02H;读扇区
	mov al, 09H         	;AL=扇区数,这里我们设定myos扇区数为9
	mov ch, 00H         	;CH=柱面号;起始编号为0
	mov cl, 02H         	;CL=起始扇区号;起始编号为1
	mov dh, 00H         	;DH=磁头号;起始编号为0
	mov dl, 00H        		;DL=驱动器号;这里是软盘
	int 13H 				;调用读磁盘BIOS的13h功能
	;引导扇区程序已加载到指定内存区域中
	jmp 1000H:0100H
	
Message:
	db "17341178 XueWeihao", 0DH, 0AH
	db "Waiting......"
	MessageLength  equ ($-Message) 
	times 510-($-$$) db 0 	;填充剩下的空间;使生成的二进制代码恰好为512字节
	dw 0xaa55 				;结束标志
	   