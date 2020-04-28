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

LoadnEx:
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

AfterRun:
   jmp $           			;����ѭ��	
	
Message:
    db '17341178 ', 0DH, 0AH
    db 'XueWeihao'
	MessageLength equ ($-Message)
	times 510-($-$$) db 0 	;���ʣ�µĿռ�;ʹ���ɵĶ����ƴ���ǡ��Ϊ512�ֽ�
	dw 0xaa55 				;������־


Dn_Rt equ 1         		;D-Down	;1����
Up_Rt equ 2         		;U-Up	;2����
Up_Lt equ 3         		;R-right;3����
Dn_Lt equ 4         		;L-Left	;4����
delay equ 50000 			;��ʱ���ӳټ���;���ڿ��ƻ�����ٶ�
ddelay equ 580	 			;��ʱ���ӳټ���;���ڿ��ƻ�����ٶ�

start:
	mov ax, cs
	mov ds, ax 				;DS=CS
	mov es, ax 				;ES=CS
	mov ax, 0B800H 			;�ı������Դ���ʼ��ַ
	mov gs,	ax 				;ȫ�ֶμĴ���GS=B800H

loop1:
	dec word[count] 		;�ݼ���������
	jnz loop1 				;����0����ת��loop1
	mov word[count], delay
	dec word[dcount] 		;�ݼ���������
	jnz loop1
	mov word[count], delay
	mov word[dcount], ddelay
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
	mov ax, 25				;����к�=25-1=24
	sub ax, bx				;����к�-��ǰ�к�
	jz dr2ur				;����ﵽ����к�;����ת��dr2ur
	mov bx, word[y]			;BX=��ǰ�к�
	mov ax, 80				;����к�=80-1=79
	sub ax, bx				;����к�-��ǰ�к�
	jz dr2dl				;����ﵽ����к�;����ת��dr2dl
	jmp show				;��ʾ��һʱ���ַ�λ��	
dr2ur:
    mov word[x],23			;��һʱ���к�=23
    mov byte[rdul],Up_Rt	;�����Ϸ��˶�
    jmp show				;��ʾ��һʱ���ַ�λ��
dr2dl:
    mov word[y],78			;��һʱ���к�=78
    mov byte[rdul],Dn_Lt	;�����·��˶�
    jmp show				;��ʾ��һʱ���ַ�λ��


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
	jmp show				;��ʾ��һʱ���ַ�λ��
ur2ul:
    mov word[y], 78			;��һʱ���к�=78
    mov byte[rdul],Up_Lt	;�����Ϸ��˶�
    jmp show				;��ʾ��һʱ���ַ�λ��
ur2dr:
    mov word[x],1			;��һʱ���к�=1
    mov byte[rdul],Dn_Rt	;�����·��˶�
    jmp show				;��ʾ��һʱ���ַ�λ��

;�����Ϸ��˶�
UpLt:
	dec word[x]				;�м�1
	dec word[y]				;�м�1
	mov bx, word[x]			;BX=��ǰ�к�
	mov ax, -1				;��С�к�=-1+1=0
	sub ax, bx				;��С�к�-��ǰ�к�
	jz ul2dl				;����ﵽ��С�к�;����ת��ul2dl
	mov bx, word[y]			;BX=��ǰ�к�
	mov ax,	-1				;��С�к�=-1+1=0
	sub ax, bx				;��С�к�-��ǰ�к�
	jz ul2ur				;����ﵽ��С�к�;����ת��ul2ur
	jmp show				;��ʾ��һʱ���ַ�λ��
ul2dl:
    mov word[x], 1			;��һʱ���к�=1
    mov byte[rdul], Dn_Lt	;�����·��˶�
    jmp show				;��ʾ��һʱ���ַ�λ��
ul2ur:
    mov word[y], 1			;
    mov byte[rdul], Up_Rt	;�����Ϸ��˶�
    jmp show				;��ʾ��һʱ���ַ�λ��

;�����·��˶�
DnLt:
	inc word[x]				;�м�1
	dec word[y]				;�м�1
	mov bx, word[y]			;BX=��ǰ�к�
	mov ax, -1				;��С�к�=-1+1=0		
	sub ax, bx				;��ǰ�к�-��С�к�-��ǰ�к�
	jz dl2dr				;����ﵽ��С�к�;����ת��dl2dr
	mov bx, word[x]			;BX=��ǰ�к�
	mov ax, 25				;����к�=25-1=24
	sub ax, bx				;����к�-��ǰ�к�
	jz dl2ul				;����ﵽ����к�;����ת��dl2ul
	jmp show				;��ʾ��һʱ���ַ�λ��
dl2dr:
    mov word[y], 1			;��һʱ���к�=1
    mov byte[rdul], Dn_Rt	;�����·��˶�
    jmp show				;��ʾ��һʱ���ַ�λ��
dl2ul:
    mov word[x], 23			;��һʱ���к�=23
    mov byte[rdul], Up_Lt	;�����Ϸ��˶�
    jmp show				;��ʾ��һʱ���ַ�λ��


show:
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
	jmp next				;��ת��next;�����ظ�ִ��even
even:
	mov bx, 2				
	mul bx					;ÿ���ַ�ռ2Bytes
	mov bp, ax				
	mov ah, 010H			;���׺�������˸
next:
	mov al, byte[char] 		;AL=��ʾ�ַ�ֵ
	mov word[gs:bp], ax 	;��ʾ�ַ���ASCII��ֵ
	jmp loop1				;��ת��loop1

end:
	jmp $          			;ֹͣ��������ѭ��


datadef:
	count dw delay
	dcount dw ddelay
	rdul db Dn_Rt    ; �������˶�
	x dw 1
	y dw 3
	char db 'A'
