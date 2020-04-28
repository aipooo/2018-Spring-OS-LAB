extrn _Current_Process
extrn _Save_Process
extrn _Schedule
extrn _Have_Program
extrn _special
extrn _Program_Num
extrn _CurrentPCBno
extrn _Segment  

;************ *****************************
; *SCOPY@                                 *
;****************** ***********************
; 实参为局部字符串带初始化异常问题的补钉程序
public SCOPY@
SCOPY@ proc 
		arg_0 = dword ptr 6
		arg_4 = dword ptr 0ah
		push bp
			mov bp,sp
		push si
		push di
		push ds
			lds si,[bp+arg_0]
			les di,[bp+arg_4]
			cld
			shr cx,1
			rep movsw
			adc cx,cx
			rep movsb
		pop ds
		pop di
		pop si
		pop bp
		retf 8
SCOPY@ endp

;*************** ********************
; 清屏
public _cls
_cls proc 
	mov ax,0003H
	int	10h		; 显示中断
	ret
_cls endp


; 字符输出
public _printchar
_printChar proc 
	push bp
		mov bp,sp
		mov al,[bp+4]
		mov bl,0
		mov ah,0eh
		int 10h
		mov sp,bp
	pop bp
	ret
_printchar endp


; 读入一个字符
public _getchar
_getchar proc
	mov ah,0
	int 16h
	mov byte ptr[_in],al
	ret
_getchar endp


; 获取时间
public _gettime
_gettime proc 
    push ax
    push bx
    push cx
    push dx		
		
    mov ah,2h
    int 1ah

	mov byte ptr[_hour], ch      ;将时放到hour
	mov byte ptr[_min], cl       ;将分放到min
	mov byte ptr[_sec], dh       ;将秒放到sec

	pop dx
	pop cx
	pop bx
	pop ax
	ret
_gettime endp



; 加载并运行程序
public _run
_run proc 
    push ax
    push bx
    push cx
    push dx
	push es
	
	xor ax,ax
	mov es,ax
	push word ptr es:[9*4]                  ; 保存 9h 中断
	pop word ptr ds:[0]
	push word ptr es:[9*4+2]
	pop word ptr ds:[2]

	mov word ptr es:[24h],offset keyDo		; 设置键盘中断向量的偏移地址
	mov ax,cs 
	mov word ptr es:[26h],ax
	
		mov ax, 1000h
		mov es, ax 		                
		mov bx, 7e00h           ;ES:BX=读入数据到内存中的存储地址
		mov ah, 2 		        ;功能号
		mov al, 1 	            ;要读入的扇区数1
		mov dl, 0               ;软盘驱动器号
		mov dh, 1 		        ;磁头号
		mov ch, 0               ;柱面号
		mov cl, byte ptr[_num]  ;起始扇区号（编号从1开始）
		int 13H 		        ;调用13H号中断
		mov bx, 7e00h           ;将偏移量放到 bx
		call bx           		;跳转到该内存地址
		
	xor ax,ax
	mov es,AX
	push word ptr ds:[0]                     ; 恢复 9h 中断
	pop word ptr es:[9*4]
	push word ptr ds:[2]
	pop word ptr es:[9*4+2]
	int 9h	
		
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_run endp

	
public _another_load
_another_load proc
    push ax
	push bp
	
	mov bp,sp
	
    mov ax,[bp+6]      	;段地址 ; 存放数据的内存基地址
	mov es,ax          	;设置段地址（不能直接mov es,段地址）
	mov bx,100h        	;偏移地址; 存放数据的内存偏移地址
	mov ah,2           	;功能号
	mov al,1          	;扇区数
	mov dl,0          	;驱动器号 ; 软盘为0，硬盘和U盘为80H
	mov dh,1          	;磁头号 ; 起始编号为0
	mov ch,0          	;柱面号 ; 起始编号为0
	mov cl,[bp+8]       ;起始扇区号 ; 起始编号为1
	int 13H          	; 调用中断
	
	pop bp
	pop ax
	
	ret
_another_load endp



Finite dw 0	
Pro_Timer:
;*****************************************
;*                Save                   *
; ****************************************
    cmp word ptr[_Program_Num],0
	jnz Save
	jmp No_Progress
Save:
	inc word ptr[Finite]
	cmp word ptr[Finite],800
	jnz Lee 
    mov word ptr[_CurrentPCBno],0
	mov word ptr[Finite],0
	mov word ptr[_Program_Num],0
	mov word ptr[_Segment],2000h
	jmp Pre
Lee:
    push ss
	push ax
	push bx
	push cx
	push dx
	push sp
	push bp
	push si
	push di
	push ds
	push es
	.386
	push fs
	push gs
	.8086

	mov ax,cs
	mov ds, ax
	mov es, ax

	call near ptr _Save_Process
	call near ptr _Schedule 
	
Pre:
	mov ax, cs
	mov ds, ax
	mov es, ax
	
	call near ptr _Current_Process
	mov bp, ax

	mov ss,word ptr ds:[bp+0]         
	mov sp,word ptr ds:[bp+16] 

	cmp word ptr ds:[bp+32],0 
	jnz No_First_Time

;*****************************************
;*                Restart                *
; ****************************************
Restart:
    call near ptr _special
	
	push word ptr ds:[bp+30]
	push word ptr ds:[bp+28]
	push word ptr ds:[bp+26]
	
	push word ptr ds:[bp+2]
	push word ptr ds:[bp+4]
	push word ptr ds:[bp+6]
	push word ptr ds:[bp+8]
	push word ptr ds:[bp+10]
	push word ptr ds:[bp+12]
	push word ptr ds:[bp+14]
	push word ptr ds:[bp+18]
	push word ptr ds:[bp+20]
	push word ptr ds:[bp+22]
	push word ptr ds:[bp+24]

	pop ax
	pop cx
	pop dx
	pop bx
	pop bp
	pop si
	pop di
	pop ds
	pop es
	.386
	pop fs
	pop gs
	.8086

	push ax         
	mov al,20h
	out 20h,al
	out 0A0h,al
	pop ax
	iret

No_First_Time:	
	add sp,16 
	jmp Restart
	
No_Progress:
    call another_Timer
	
	push ax         
	mov al,20h
	out 20h,al
	out 0A0h,al
	pop ax
	iret
	
	

SetTimer: 
    push ax
    mov al,34h   ; 设控制字值 
    out 43h,al   ; 写控制字到控制字寄存器 
    mov ax,29830 ; 每秒 20 次中断（50ms 一次） 
    out 40h,al   ; 写计数器 0 的低字节 
    mov al,ah    ; AL=AH 
    out 40h,al   ; 写计数器 0 的高字节 
	pop ax
	ret

public _setClock
_setClock proc
    push ax
	push bx
	push cx
	push dx
	push ds
	push es
	
    call SetTimer
    xor ax,ax
	mov es,ax
	mov word ptr es:[20h],offset Pro_Timer
	mov ax,cs
	mov word ptr es:[22h],cs
	
	pop ax
	mov es,ax
	pop ax
	mov ds,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_setClock endp


another_Timer:
    push ax
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	
	mov ax,cs
	mov ds,ax

	cmp byte ptr [ds:count],0
	jz case1
	cmp byte ptr [ds:count],1
	jz case2
	cmp byte ptr [ds:count],2
	jz case3
	
case1:	
    inc byte ptr [ds:count]
	mov al,'/'
	jmp show
case2:	
    inc byte ptr [ds:count]
	mov al,'\'
	jmp show
case3:	
    mov byte ptr [ds:count],0
	mov al,'|'
	jmp show
	
show:
    mov bx,0b800h
	mov es,bx
	mov ah,0ah
	mov es:[((80*24+78)*2)],ax
	
	pop ax
	mov ds,ax
	pop ax
	mov es,ax
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	ret

	count db 0
	

