for src in $(ls ./*.lex):
do
	echo $src
	rm -f $src
done
