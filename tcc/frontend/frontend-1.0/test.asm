FUNC @main:
var i

push 0
pop i

_begWhile_0:
push i
push 10
	cmplt
	jz _endWhile_0
push i
push 1
	add
pop i

_begIf_1:
push i
push 3
	cmpeq
push i
push 5
	cmpeq
	or
	jz _elIf_1
	jmp _begWhile_0
