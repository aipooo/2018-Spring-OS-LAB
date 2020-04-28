org 07C00H 					;BIOS���������������ص�0:7C00h��;����ʼִ��

Start:
	mov ax, cs    			;�������μĴ���ֵ��CS��ͬ
	mov ds, ax    			;���ݶ�ds
	mov bp, Message 		;BP=��ǰ����ƫ�Ƶ�ַ
	mov ax, ds 				;ES:BP=������ַ:��ƫ�Ƶ�ַ=����ַ
	mov es, ax 				;��ES=DS
	mov cx, MessageLength 	;CX=������ 
	mov ax, 01301H 			;AH=13h(���ܺ�;��ʾ�ַ���);AL=01h(������ڴ�β)
	mov bx, 001FH 			;ҳ��Ϊ0(BH=0);���װ��ָ�������˸(BL=1Fh)
	mov dx, 0				;�к�dh=0;�к�dl=0
	int 10H 				;10h���ж�
	mov ah,0				;�Ӽ��̶����ַ���ah	
	int 16H					;16h���ж�
	mov ah, 0EH	
	mov bl, 0
	int 10H					;10h���ж�
	
cmp al, '1'
je LoadnFirst
cmp al, '2'
je LoadnSecond
cmp al, '3'
je LoadnThird
cmp al, '4'
je LoadnFourth



LoadnFirst:
	;��ȡ����������ES:BX��
	mov ax, cs        		;�ε�ַ
	mov es, ax        		;ES=�ε�ַ
	mov bx, 7E00H 			;BX=ƫ�Ƶ�ַ
	mov ah, 02H         	;���ܺ�02H;������
	mov al, 01H         	;AL=������
	mov ch, 00H         	;CH=�����;��ʼ���Ϊ0
	mov cl, 02H         	;CL=��ʼ������;��ʼ���Ϊ1
	mov dh, 00H         	;DH=��ͷ��;��ʼ���Ϊ0
	mov dl, 00H        		;DL=��������;����������
	int 13H 				;���ö�����BIOS��13h����
	;�������������Ѽ��ص�ָ���ڴ�������
	jmp 7E00H
	
LoadnSecond:
	;��ȡ����������ES:BX��
	mov ax, cs        		;�ε�ַ
	mov es, ax        		;ES=�ε�ַ
	mov bx, 8000H 			;BX=ƫ�Ƶ�ַ
	mov ah, 02H         	;���ܺ�02H;������
	mov al, 01H         	;AL=������
	mov ch, 00H         	;CH=�����;��ʼ���Ϊ0
	mov cl, 03H         	;CL=��ʼ������;��ʼ���Ϊ1
	mov dh, 00H         	;DH=��ͷ��;��ʼ���Ϊ0
	mov dl, 00H        		;DL=��������;����������
	int 13H 				;���ö�����BIOS��13h����
	;�������������Ѽ��ص�ָ���ڴ�������
	jmp 8000H

LoadnThird:
	;��ȡ����������ES:BX��
	mov ax, cs        		;�ε�ַ
	mov es, ax        		;ES=�ε�ַ
	mov bx, 8200H 			;BX=ƫ�Ƶ�ַ
	mov ah, 02H         	;���ܺ�02H;������
	mov al, 01H         	;AL=������
	mov ch, 00H         	;CH=�����;��ʼ���Ϊ0
	mov cl, 04H         	;CL=��ʼ������;��ʼ���Ϊ1
	mov dh, 00H         	;DH=��ͷ��;��ʼ���Ϊ0
	mov dl, 00H        		;DL=��������;����������
	int 13H 				;���ö�����BIOS��13h����
	;�������������Ѽ��ص�ָ���ڴ�������
	jmp 8200H

LoadnFourth:
	;��ȡ����������ES:BX��
	mov ax, cs        		;�ε�ַ
	mov es, ax        		;ES=�ε�ַ
	mov bx, 8400H 			;BX=ƫ�Ƶ�ַ
	mov ah, 02H         	;���ܺ�02H;������
	mov al, 01H         	;AL=������
	mov ch, 00H         	;CH=�����;��ʼ���Ϊ0
	mov cl, 05H         	;CL=��ʼ������;��ʼ���Ϊ1
	mov dh, 00H         	;DH=��ͷ��;��ʼ���Ϊ0
	mov dl, 00H        		;DL=��������;����������
	int 13H 				;���ö�����BIOS��13h����
	;�������������Ѽ��ص�ָ���ڴ�������
	jmp 8400H		

AfterRun:
   jmp $           			;����ѭ��	
	
Message:
    db '17341178 ', 0DH, 0AH
    db 'XueWeihao'
	MessageLength equ ($-Message)
	times 510-($-$$) db 0 	;���ʣ�µĿռ�;ʹ���ɵĶ����ƴ���ǡ��Ϊ512�ֽ�
	dw 0xaa55 				;������־
		
;Proj1
delay1 equ 10000
ddelay1 equ 800

start1:
	mov ax, cs
	mov ds, ax 				;DS=CS
	mov es, ax 				;ES=CS
	mov ax, 0B800H 			;�ı������Դ���ʼ��ַ
	mov gs,	ax 				;ȫ�ֶμĴ���GS=B800H
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
	dec word[count1] 		;�ݼ���������
	jnz show1 				;����0����ת��show1
	mov word[count1], delay1
	dec word[dcount1] 		;�ݼ���������
	jnz show1
	mov word[count1], delay1
	mov word[dcount1], ddelay1
	
	push dx
	mov ax, word[x1]			
	mov bx, 80				
	mul bx			
	add ax, word[y1]		;��ǰ���
	mov bx, 2				
	mul bx					;ÿ���ַ�ռ2Bytes
	mov bp, ax			
	mov ah, 10H 			;��װ��ָ�������˸
	mov al, byte[char1]		;AL=��ʾ�ַ�ֵ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov word[gs:bp], ax 	;��ʾ�ַ���ASCII��ֵ
	pop dx
	ret

datadef1:
	x1 dw 3  ;15
	y1 dw 3
	col1 dw 3
	char1 db ' '
	count1 dw delay1
	dcount1 dw ddelay1
	times 510+512-($-$$) db 0 	;���ʣ�µĿռ�;ʹ���ɵĶ����ƴ���ǡ��Ϊ512�ֽ�
	dw 0xaa55 						;������־

	
	
;project2	
Dn_Rt equ 1         		;D-Down	;1����
Up_Rt equ 2         		;U-Up	;2����
Up_Lt equ 3         		;R-right;3����
Dn_Lt equ 4         		;L-Left	;4����
delay2 equ 10000 			;��ʱ���ӳټ���;���ڿ��ƻ�����ٶ�
ddelay2 equ 800	 			;��ʱ���ӳټ���;���ڿ��ƻ�����ٶ�

start2:
	mov ax, cs
	mov ds, ax 				;DS=CS
	mov es, ax 				;ES=CS
	mov ax, 0B800H 			;�ı������Դ���ʼ��ַ
	mov gs,	ax 				;ȫ�ֶμĴ���GS=B800H

loop2:
	dec word[count2] 		;�ݼ���������
	jnz loop2 				;����0����ת��loop2
	mov word[count2], delay2
	dec word[dcount2] 		;�ݼ���������
	jnz loop2
	mov word[count2], delay2
	mov word[dcount2], ddelay2
	;�������ָ��ȷ�����ַ��ʼ���˶�����
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

;�����·��˶�
DnRt:						
	inc word[x]				;�м�1
	inc word[y]				;�м�1
	mov bx, word[x]			;BX=��ǰ�к�
	mov ax, 12				;����к�=12-1=11
	sub ax, bx				;����к�-��ǰ�к�
	jz dr2ur				;����ﵽ����к�;����ת��dr2ur
	mov bx, word[y]			;BX=��ǰ�к�
	mov ax, 80				;����к�=80-1=79
	sub ax, bx				;����к�-��ǰ�к�
	jz dr2dl				;����ﵽ����к�;����ת��dr2dl
	jmp show2				;��ʾ��һʱ���ַ�λ��	
dr2ur:
	cmp word[y], 80
	jz 7c00H
    mov word[x],10			;��һʱ���к�=10
    mov byte[rdul],Up_Rt	;�����Ϸ��˶�
    jmp show2				;��ʾ��һʱ���ַ�λ��
dr2dl:
	cmp word[x], 12
	jz 7c00H
    mov word[y],78			;��һʱ���к�=78
    mov byte[rdul],Dn_Lt	;�����·��˶�
    jmp show2				;��ʾ��һʱ���ַ�λ��


;�����Ϸ��˶�
UpRt:
	dec word[x]				;�м�1
	inc word[y]				;�м�1
	mov bx, word[y]			;BX=��ǰ�к�
	mov ax, 80				;����к�=80-1=79
	sub ax, bx				;����к�-��ǰ�к�
	jz ur2ul				;����ﵽ����к�;����ת��ur2ul
	mov bx, word[x]			;BX=��ǰ����
	mov ax, -1				;��С�к�=-1+1=0
	sub ax, bx				;��С�к�-��ǰ�к�	
	jz ur2dr				;����ﵽ��С�к�;����ת��ur2dr
	jmp show2				;��ʾ��һʱ���ַ�λ��
ur2ul:
	cmp word[x], -1
	jz 7c00H
    mov word[y], 78			;��һʱ���к�=78
    mov byte[rdul],Up_Lt	;�����Ϸ��˶�
    jmp show2				;��ʾ��һʱ���ַ�λ��
ur2dr:
	cmp word[y], 80
	jz 7c00H
    mov word[x],1			;��һʱ���к�=1
    mov byte[rdul],Dn_Rt	;�����·��˶�
    jmp show2				;��ʾ��һʱ���ַ�λ��

;�����Ϸ��˶�
UpLt:
	dec word[x]				;�м�1
	dec word[y]				;�м�1
	mov bx, word[x]			;BX=��ǰ�к�
	mov ax, -1				;��С�к�=-1+1=0
	sub ax, bx				;��С�к�-��ǰ�к�
	jz ul2dl				;����ﵽ��С�к�;����ת��ul2dl
	mov bx, word[y]			;BX=��ǰ�к�
	mov ax,	38				;��С�к�=39+1=40
	sub ax, bx				;��С�к�-��ǰ�к�
	jz ul2ur				;����ﵽ��С�к�;����ת��ul2ur
	jmp show2				;��ʾ��һʱ���ַ�λ��
ul2dl:
	cmp word[y], 38
	jz 7c00H
    mov word[x], 1			;��һʱ���к�=1
    mov byte[rdul], Dn_Lt	;�����·��˶�
    jmp show2				;��ʾ��һʱ���ַ�λ��
ul2ur:
	cmp word[x], -1
	jz 7c00H
    mov word[y], 41			;��һʱ���к�=41
    mov byte[rdul], Up_Rt	;�����Ϸ��˶�
    jmp show2				;��ʾ��һʱ���ַ�λ��

;�����·��˶�
DnLt:
	inc word[x]				;�м�1
	dec word[y]				;�м�1
	mov bx, word[y]			;BX=��ǰ�к�
	mov ax, 38				;��С�к�=39+1=40		
	sub ax, bx				;��ǰ�к�-��С�к�-��ǰ�к�
	jz dl2dr				;����ﵽ��С�к�;����ת��dl2dr
	mov bx, word[x]			;BX=��ǰ�к�
	mov ax, 12				;����к�=12-1=11
	sub ax, bx				;����к�-��ǰ�к�
	jz dl2ul				;����ﵽ����к�;����ת��dl2ul
	jmp show2				;��ʾ��һʱ���ַ�λ��
dl2dr:
	cmp word[x], 12
	jz 7c00H
    mov word[y], 41			;��һʱ���к�=41
    mov byte[rdul], Dn_Rt	;�����·��˶�
    jmp show2				;��ʾ��һʱ���ַ�λ��
dl2ul:
	cmp word[y], 38
	jz 7c00H
    mov word[x], 10			;��һʱ���к�=10
    mov byte[rdul], Up_Lt	;�����Ϸ��˶�
    jmp show2				;��ʾ��һʱ���ַ�λ��


show2:
	mov ax, word[x]			
	mov bx, 80				
	mul bx					
	add ax, word[y]			;��ǰ���
	test ax, 0001H			;�жϵ�ǰ����Ƿ�Ϊ����
	jz even					;�����������;����ת��evenִ��
	mov bx, 2				
	mul bx					;ÿ���ַ�ռ2Bytes
	mov bp, ax			
	mov ah, 0CFH 			;��װ��ָ�����˸
	jmp next2				;��ת��next;�����ظ�ִ��even
even:
	mov bx, 2				
	mul bx					;ÿ���ַ�ռ2Bytes
	mov bp, ax				
	mov ah, 010H			;���׺�������˸
next2:
	mov al, byte[char] 		;AL=��ʾ�ַ�ֵ
	mov word[gs:bp], ax 	;��ʾ�ַ���ASCII��ֵ
	jmp loop2				;��ת��loop1

end:
	jmp $          			;ֹͣ��������ѭ��


datadef2:
	count2 dw delay2
	dcount2 dw ddelay2
	rdul db Dn_Rt    ; �������˶�
	x dw 4
	y dw 38
	char db ' '
	times 510+512*2-($-$$) db 0 	;���ʣ�µĿռ�;ʹ���ɵĶ����ƴ���ǡ��Ϊ512�ֽ�
	dw 0xaa55 						;������־
	
	
;proj3
delay3 equ 10000 			;��ʱ���ӳټ���;���ڿ��ƻ�����ٶ�
ddelay3 equ 800	 			;��ʱ���ӳټ���;���ڿ��ƻ�����ٶ�

start3:
	mov ax, cs
	mov ds, ax 				;DS=CS
	mov es, ax 				;ES=CS
	mov ax, 0B800H 			;�ı������Դ���ʼ��ַ
	mov gs,	ax 				;ȫ�ֶμĴ���GS=B800H
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
	dec word[count3] 		;�ݼ���������
	jnz show3 				;����0����ת��show3
	mov word[count3], delay3
	dec word[dcount3] 		;�ݼ���������
	jnz show3
	mov word[count3], delay3
	mov word[dcount3], ddelay3
	
	push dx
	mov ax, word[x3]			
	mov bx, 80				
	mul bx			
	add ax, word[y3]		;��ǰ���
	mov bx, 2				
	mul bx					;ÿ���ַ�ռ2Bytes
	mov bp, ax			
	mov ah, 20H 			;��װ��ָ�������˸
	mov al, byte[char3]		;AL=��ʾ�ַ�ֵ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov word[gs:bp], ax 	;��ʾ�ַ���ASCII��ֵ
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
	times 510+512*3-($-$$) db 0 	;���ʣ�µĿռ�;ʹ���ɵĶ����ƴ���ǡ��Ϊ512�ֽ�
	dw 0xaa55 						;������־

;Proj4
delay4 equ 10000
ddelay4 equ 800

start4:
	mov ax, cs
	mov ds, ax 				;DS=CS
	mov es, ax 				;ES=CS
	mov ax, 0B800H 			;�ı������Դ���ʼ��ַ
	mov gs,	ax 				;ȫ�ֶμĴ���GS=B800H
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
	dec word[count4] 		;�ݼ���������
	jnz show4 				;����0����ת��show4
	mov word[count4], delay4
	dec word[dcount4] 		;�ݼ���������
	jnz show4
	mov word[count4], delay4
	mov word[dcount4], ddelay4
	
	push dx
	mov ax, word[x4]			
	mov bx, 80				
	mul bx			
	add ax, word[y4]		;��ǰ���
	mov bx, 2				
	mul bx					;ÿ���ַ�ռ2Bytes
	mov bp, ax			
	mov ah, 60H 			;��װ��ָ�������˸
	mov al, byte[char4]		;AL=��ʾ�ַ�ֵ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov word[gs:bp], ax 	;��ʾ�ַ���ASCII��ֵ
	pop dx
	ret

datadef4:
	x4 dw 22  
	y4 dw 39
	col4 dw 39
	char4 db ' '
	count4 dw delay4
	dcount4 dw ddelay4
	times 510+512*4-($-$$) db 0 	;���ʣ�µĿռ�;ʹ���ɵĶ����ƴ���ǡ��Ϊ512�ֽ�
	dw 0xaa55 						;������־
	



