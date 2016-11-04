while read GENE; do
echo ">"$GENE
#grep "\\b"$REGEX DEG* |cut -f 1,3,8,9  $itemsForGene | sed 's/:\w*//g' >> $2
grep "\\b"$GENE DEG* |cut -f 1,3,8,9 | sed 's/:\w*//g'
done < $1
