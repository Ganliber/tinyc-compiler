	; int a, b
	var a, b

	; a = 3
	push 3
	pop a
	jmp label2
label1:
	; b = a * 2
	push a	
	push 2
	mul
	pop b
	jmp label3
label2:
	; a = a * a
	push a
	push a
	mul
	pop a
	jmp label1
label3: 
	; print("a = %d, b = %d", a, b);
	push a
	push b
	print "a = %d, b = %d"
