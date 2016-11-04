IFS="	" # tab
while read GENE REGEX; do
	echo ">"$GENE >>$2
	#grep "\\b"$REGEX DEG* |cut -f 1,3,8,9  $itemsForGene | sed 's/:\w*//g' >> $2
	grep $REGEX DEG* |cut -f 1,3,8,9 | sed 's/:\w*//g' >> $2
done < $1
