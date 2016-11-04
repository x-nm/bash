IFS="	" # tab
while read GENE REGEX; do
	echo ">"$GENE 
	grep $REGEX gene_* 
done < $1
