.model tiny

org 100h

.DATA
fl dw ?
n dw ? ; ������ �������
array dw 255 dup(?); ������
myes DB 'yes','$'
mno DB 'no','$'
mInpSize DB  '������� ������ �������:' , '$'
mInpArray DB '������� �������� ����� Enter: ','$'
crlf db 0dh,0ah,'$' ; ������� ������ 13,10 �������

.CODE  
; ���� ����������� ������� � ������� AX
    mov ah,9 
    lea dx,mInpSize
    int 21h 
    call ReadInteger
    mov n,ax
    call newline
    
; ���� ������� ����� Enter
    mov cx, n	; ���������� ����������
    mov ah,9
    lea dx,mInpArray
    int 21h 
    mov bx,0 ; ������ � �������
inputarray:
	call ReadInteger	
	mov array[bx],ax
	add bx,2 
	call newline
loop inputarray

call main
;----------------------------------------------------------------
newline proc; ������� ������
    mov ah,9
    lea dx,crlf
    int 21h
    ret
newline endp
;----------------------------------------------------------------
main proc
	mov bx,0;index 
	mov di,n; size array
	mov ax,0; index last positive
	mov si,0fffh; index first negative
	mov cx,0; flag is first negative          
	action:
		cmp array[bx],0
		jle negative
		jmp positive
	negative:
		cmp cx,0
		je firstneg
		jmp next
	firstneg:
		mov cx,1; set flag =1
		mov si,bx
		jmp next	
	positive:
		mov ax,bx
		jmp next	
	next:
		add bx,2
		dec di	
		jnz action
		jz endwork	
	endwork:	
		cmp ax,si
		jle writeyes	
		lea dx,mno
		jmp print	
	writeyes:	
		lea dx,myes	
		jmp print
		
	print:  mov  ah,9       
	        int  21h              
	        mov  ah,4ch                 
	        int  21h
	ret
main endp
;----------------------------------------------------------------
ReadInteger proc  ; �� 65535
    push    cx      ; ���������� ���������
    push    dx
    push    bx   
    mov     fl,0    ; ���� �������������� �����(0 - �����., 1 -�����.)
    mov     cx, 0  
    mov     bx, 10 ; ��������� �� bx
    call    ReadChar  ; ���� �������
    cmp     al,'-'   ; ���� ����� - ���������� ����
    je      minus
    jmp     go
minus:
    mov     fl,1  
read: 
    call    ReadChar   ; ���� ���������� �������
go: cmp     al, 13     ; ������ Enter ?
    je      readEnd    ; ��- �������� ���� ����� ��������� � ax    
    sub     al, '0'    ;������� �� ���� ������� ��� ������� '0' char -> int
    mov     ah, 0      
    xchg    cx, ax  ; ��������� ax � cx
    mul     bx      ;ax= al*bx ��� dx:ax=ax*bx ��������� ����� ��� �����
    add     ax, cx  ; ��, ��� ��������, ������� � ���, ��� ���������
    xchg    ax, cx  ; ����� � ax ��������
    jmp     read  
readEnd:  
    xchg    ax, cx  ; ����� � ax ��������
    cmp     fl,1
    je      setMinus
    jmp     popStack
setMinus:
    neg     ax ; ��������� �����
popStack:    
    pop     bx 
    pop     dx 
    pop     cx     
    ret  
ReadInteger endp  
;----------------------------------------------------------------
readChar proc
	mov ah,1
	int 21h
	ret
readChar endp	 
;----------------------------------------------------------------
end start