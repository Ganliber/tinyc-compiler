run: hide-digits
	./hide-digits

hide-digits: lex.yy.c
	gcc -o $@ $<

lex.yy.c: hide-digits.l
	flex $<
