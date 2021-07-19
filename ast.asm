section .data
    delim db " ", 0

section .bss
    root resd 1

section .text

extern check_atoi
extern print_tree_inorder
extern print_tree_preorder
extern evaluate_tree
extern calloc
extern printf

global create_tree
global iocla_atoi

iocla_atoi:
	;iau stringul de schimbat
	mov edx, [ebp + 8]
	push ebx
	push edx
	xor eax, eax
	xor ebx, ebx
	mov ecx, [edx]
	;pastrez primul caracter
	;ca sa vad daca am un numar negativ
	mov bl, [ecx]
	cmp bl, '-'
	push ebx	
	jne positive
	inc ecx

	positive:
	cmp bl, 0
	je end3
	sub bl, '0'
	
	mov bh, [ecx + 1]
	cmp bh, 0
	je only_once

	xor edx, edx
	xor ebx, ebx
	mov bl, [ecx]
	sub bl, '0'
	add eax, ebx
	mov edx, eax
	xor ebx, ebx
	add ebx, 9

	mul_10:
	add eax, edx
	dec ebx
	cmp ebx, 0
	jne mul_10
	jmp continue

	only_once:
	xor ebx, ebx
	mov bl, [ecx]
	sub bl, '0'
	add eax, ebx

	continue:
	inc ecx
	xor ebx, ebx
	mov bl, [ecx]
	jmp positive
	jmp end3
	
end3:
	;verific daca numarul e negativ
	pop ebx
	cmp bl, '-'
	je end4
	jne end5
	end4:
	neg eax
	end5:
	pop edx
	pop ebx	

ret

build_tree:
	push ebp
	mov ebp, esp

	mov edx, [ebp + 8]
	
	cmp byte [edi], 0
	je end
	; creez nodul
	push edx
	push 4
	push 3
	call calloc
	add esp, 8
	pop edx

	mov [edx], eax
	push eax
	;creez 'data' al noduluo
	push edx
	push 12
	push 1
	call calloc
	add esp, 8	
	pop edx

	;verific daca am operator
	;sau numar
	xor ecx, ecx
	do:
	mov cl, [edi]
	cmp cl, 0
	je end
	cmp cl, ' '
	je incrs
	cmp cl, '+'
	je symbol
	cmp cl, '/'
	je symbol
	cmp cl, '*'
	je symbol
	cmp cl, '0'
	jae number
	mov ch, [edi + 1]
	cmp ch, ' '
	je symbol
	jne number	
	incrs:
	inc edi
	jmp do

	symbol:
	inc edi
	mov [eax], cl
	
	pop edx
	mov [edx], eax
	;apelul recursiv pentru nodul stang
left:
	xor ecx, ecx
	mov ecx, edx 
	add ecx, 4
	push ecx
	call build_tree
	pop ecx
	;apelul recursiv pentru nodul drept
right:
	add ecx, 4
	push ecx
	call build_tree
	add esp, 4
	jmp end

	;daca dau de un numar
	;il adaug in data
	number:
	push ebx
	mov ebx, eax
	parse_str:
	mov [ebx], cl
	xor ecx, ecx
	inc ebx
	inc edi
	mov cl, [edi]
	cmp cl, 0
	je clos
	cmp cl, ' '
	jne parse_str
	clos:
	pop ebx

	pop edx
	mov [edx], eax

	end:
leave
ret

create_tree:

    enter 0, 0
    xor eax, eax
    mov edi, [ebp + 8]
    ;pastrez adresa initiala in root
    push root
    call build_tree
    add esp, 4

    mov eax, [root]

    leave
    ret