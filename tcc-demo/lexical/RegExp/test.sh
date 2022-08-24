for src in $(ls sample/*.c):
do
	./scanner < $src >  $src.lex
done
