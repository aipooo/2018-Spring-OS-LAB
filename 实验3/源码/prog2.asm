;project2
org 1400h	
Dn_Rt equ 1         		;D-Down	;1右下
Up_Rt equ 2         		;U-Up	;2右上
Up_Lt equ 3         		;R-right;3左上
Dn_Lt equ 4         		;L-Left	;4左下
delay2 equ 10000 			;计时器延迟计数;用于控制画框的速度
ddelay2 equ 800	 			;计时器延迟计数;用于控制画框的速度

start2:
	call clear
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
	jz quit
    mov word[x],10			;下一时刻行号=10
    mov byte[rdul],Up_Rt	;向右上方运动
    jmp show2				;显示下一时刻字符位置
dr2dl:
	cmp word[x], 12
	jz quit
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
	jz quit
    mov word[y], 78			;下一时刻列号=78
    mov byte[rdul],Up_Lt	;向左上方运动
    jmp show2				;显示下一时刻字符位置
ur2dr:
	cmp word[y], 80
	jz quit
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
	jz quit
    mov word[x], 1			;下一时刻行号=1
    mov byte[rdul], Dn_Lt	;向左下方运动
    jmp show2				;显示下一时刻字符位置
ul2ur:
	cmp word[x], -1
	jz quit
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
	jz quit
    mov word[y], 41			;下一时刻列号=41
    mov byte[rdul], Dn_Rt	;向右下方运动
    jmp show2				;显示下一时刻字符位置
dl2ul:
	cmp word[y], 38
	jz quit
    mov word[x], 10			;下一时刻行号=10
    mov byte[rdul], Up_Lt	;向左上方运动
    jmp show2				;显示下一时刻字符位置


show2:
	mov ax, word[x]			
	mov bx, 80				
	mul bx					
	add ax, word[y]			;当前序号
	test ax, 0001H			;判断当前序号是否为奇数
	jz evennum				;如果不是奇数;则跳转至even执行
	mov bx, 2				
	mul bx					;每个字符占2Bytes
	mov bp, ax			
	mov ah, 0CFH 			;红底白字高亮闪烁
	jmp next2				;跳转至next;避免重复执行even
evennum:
	mov bx, 2				
	mul bx					;每个字符占2Bytes
	mov bp, ax				
	mov ah, 010H			;蓝底黑字无闪烁
next2:
	mov al, byte[char] 		;AL=显示字符值
	mov word[gs:bp], ax 	;显示字符的ASCII码值
	jmp loop2				;跳转至loop1

clear:
	mov ax,0003H    		;清屏属性
    int 10H         		;调用中断
	ret             		;返回
	
quit:
	ret


datadef2:
	count2 dw delay2
	dcount2 dw ddelay2
	rdul db Dn_Rt    ; 向右下运动
	x dw 4
	y dw 38
	char db ' '
	times 510+512*2-($-$$) db 0 	;填充剩下的空间;使生成的二进制代码恰好为512字节
	dw 0xaa55 						;结束标志
	