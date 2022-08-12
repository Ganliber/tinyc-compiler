; sum(1,2);
; void sum(int a, int b) {return a+b;}

var a, b, c
push 1
push 2
$sum
exit 0

FUNC @sum:
	arg a, b
	push a
	push b
	add
	ret ~
ENDFUNC
