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
		mov bx, 1c00h           ;ES:BX=读入数据到内存中的存储地址
		mov ah, 2 		        ;功能号
		mov al, 1 	            ;要读入的扇区数1
		mov dl, 0               ;软盘驱动器号
		mov dh, 0 		        ;磁头号
		mov ch, 0               ;柱面号
		mov cl, byte ptr[_num]  ;起始扇区号（编号从1开始）
		int 13H 		        ;调用13H号中断
		mov bx, 1c00h           ;将偏移量放到 bx
		call 1000h:bx           ;跳转到该内存地址
		
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


;设置时钟中断向量（08h），初始化段寄存器
;系统时钟中断，自动执行，无需调用
delay equ 3
count db delay				
ch1 db '|'
ch2 db '/'
ch3 db '\'        
remark db 3
Timer:
    push ax
	push bx
	push cx
	push dx
	push bp
    push es
		dec byte ptr [count]				
		jnz int_end						                   
		cmp byte ptr [remark],3             
		jz first
		cmp byte ptr [remark],2            
		jz second
		mov byte ptr [remark],4             
		jmp third
	first:
		mov bp,offset ch1
		jmp show
	second:
		mov bp,offset ch2
		jmp show
	third:
		mov bp,offset ch3
		jmp show

	show:
		dec byte ptr [remark]
		mov ah,13h 	                        ; 功能号
		mov al,0                     		; 光标放到串尾
		mov bl,0fh 	                        ; 亮白
		mov bh,0 	                    	; 第0页
		mov cx,1 	                        ; 串长为 1
		mov dh,0 	                        ; 第0行
		mov dl,79							; 第79列
	loop1:	
		int 10h								; 调用10H号中断
		add dh,2	
		cmp dh,24
		jne loop1                    	
		mov byte ptr es:[count],delay
int_end:
	mov al,20h					        ; AL = EOI
	out 20h,al						    ; 发送EOI到主8529A
	out 0A0h,al					        ; 发送EOI到从8529A
	pop es
	pop bp
	pop dx 
	pop cx
	pop bx
	pop ax
	iret		




	

