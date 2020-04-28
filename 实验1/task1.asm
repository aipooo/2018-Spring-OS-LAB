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

LoadnEx:
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

AfterRun:
   jmp $           			;无限循环	
	
Message:
    db '17341178 ', 0DH, 0AH
    db 'XueWeihao'
	MessageLength equ ($-Message)
	times 510-($-$$) db 0 	;填充剩下的空间;使生成的二进制代码恰好为512字节
	dw 0xaa55 				;结束标志


Dn_Rt equ 1         		;D-Down	;1右下
Up_Rt equ 2         		;U-Up	;2右上
Up_Lt equ 3         		;R-right;3左上
Dn_Lt equ 4         		;L-Left	;4左下
delay equ 50000 			;计时器延迟计数;用于控制画框的速度
ddelay equ 580	 			;计时器延迟计数;用于控制画框的速度

start:
	mov ax, cs
	mov ds, ax 				;DS=CS
	mov es, ax 				;ES=CS
	mov ax, 0B800H 			;文本窗口显存起始地址
	mov gs,	ax 				;全局段寄存器GS=B800H

loop1:
	dec word[count] 		;递减计数变量
	jnz loop1 				;大于0则跳转至loop1
	mov word[count], delay
	dec word[dcount] 		;递减计数变量
	jnz loop1
	mov word[count], delay
	mov word[dcount], ddelay
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
	mov ax, 25				;最大行号=25-1=24
	sub ax, bx				;最大行号-当前行号
	jz dr2ur				;如果达到最大行号;则跳转至dr2ur
	mov bx, word[y]			;BX=当前列号
	mov ax, 80				;最大列号=80-1=79
	sub ax, bx				;最大列号-当前列号
	jz dr2dl				;如果达到最大列号;则跳转至dr2dl
	jmp show				;显示下一时刻字符位置	
dr2ur:
    mov word[x],23			;下一时刻行号=23
    mov byte[rdul],Up_Rt	;向右上方运动
    jmp show				;显示下一时刻字符位置
dr2dl:
    mov word[y],78			;下一时刻列号=78
    mov byte[rdul],Dn_Lt	;向左下方运动
    jmp show				;显示下一时刻字符位置


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
	jmp show				;显示下一时刻字符位置
ur2ul:
    mov word[y], 78			;下一时刻列号=78
    mov byte[rdul],Up_Lt	;向左上方运动
    jmp show				;显示下一时刻字符位置
ur2dr:
    mov word[x],1			;下一时刻行号=1
    mov byte[rdul],Dn_Rt	;向右下方运动
    jmp show				;显示下一时刻字符位置

;向左上方运动
UpLt:
	dec word[x]				;行减1
	dec word[y]				;列减1
	mov bx, word[x]			;BX=当前行号
	mov ax, -1				;最小行号=-1+1=0
	sub ax, bx				;最小行号-当前行号
	jz ul2dl				;如果达到最小行号;则跳转至ul2dl
	mov bx, word[y]			;BX=当前列号
	mov ax,	-1				;最小列号=-1+1=0
	sub ax, bx				;最小列号-当前列号
	jz ul2ur				;如果达到最小列号;则跳转至ul2ur
	jmp show				;显示下一时刻字符位置
ul2dl:
    mov word[x], 1			;下一时刻行号=1
    mov byte[rdul], Dn_Lt	;向左下方运动
    jmp show				;显示下一时刻字符位置
ul2ur:
    mov word[y], 1			;
    mov byte[rdul], Up_Rt	;向右上方运动
    jmp show				;显示下一时刻字符位置

;向左下方运动
DnLt:
	inc word[x]				;行加1
	dec word[y]				;列减1
	mov bx, word[y]			;BX=当前列号
	mov ax, -1				;最小列号=-1+1=0		
	sub ax, bx				;当前列号-最小列号-当前列号
	jz dl2dr				;如果达到最小列号;则跳转至dl2dr
	mov bx, word[x]			;BX=当前行号
	mov ax, 25				;最大行号=25-1=24
	sub ax, bx				;最大列号-当前列号
	jz dl2ul				;如果达到最大列号;则跳转至dl2ul
	jmp show				;显示下一时刻字符位置
dl2dr:
    mov word[y], 1			;下一时刻列号=1
    mov byte[rdul], Dn_Rt	;向右下方运动
    jmp show				;显示下一时刻字符位置
dl2ul:
    mov word[x], 23			;下一时刻行号=23
    mov byte[rdul], Up_Lt	;向左上方运动
    jmp show				;显示下一时刻字符位置


show:
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
	jmp next				;跳转至next;避免重复执行even
even:
	mov bx, 2				
	mul bx					;每个字符占2Bytes
	mov bp, ax				
	mov ah, 010H			;蓝底黑字无闪烁
next:
	mov al, byte[char] 		;AL=显示字符值
	mov word[gs:bp], ax 	;显示字符的ASCII码值
	jmp loop1				;跳转至loop1

end:
	jmp $          			;停止画框，无限循环


datadef:
	count dw delay
	dcount dw ddelay
	rdul db Dn_Rt    ; 向右下运动
	x dw 1
	y dw 3
	char db 'A'
