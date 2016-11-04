##!/bin/bash
# cannot use in 202.120.45.100
##################################################################
# Rabbit project: screen DEG results to find KNOWN Key Genes
#
# Input: 
#	a file containing a list of FILENAME of files to process
#		(DEG_**_up/down.txt, .txt included)
#	a list of known key genes:
#		GeneSymbol	GeneRegEx
#		(ALP	\bALP[^HK])
#	a prefix of all the files to process
#		(to find out files for each key gene)
#	files to process
#		(DEG_**_up/down.txt)
# Output:
#	create an output folder
#	for each file, an output of items with known key gene screened
# 	a single result file containing items found for each gene
#	a single result file containing filenames found for each gene
# Usage: screenKeyGene.sh FILENAMES KEYGENES PREFIX
#
# Writer: xnm
# Created at 2016.09.29
##################################################################

USAGE="USAGE: ./$0 FILENAMES KEYGENES PREFIX"

if [ $# -ne 3 ]; then
        echo $USAGE
        exit 1
fi

if [ ! -d output ]; then
	mkdir output
fi

# DEFINE VARIABLES AND SETTINGS
FILENAMES=$1
KEYGENES=$2
PREFIX=$3
itemsForGene="itemsForGene.txt" # items found for each gene
filesForGene="filesForGene.txt" # filenames found for each gene
result="results.txt"

IFS="	" # tab


# 1. for each gene, find accordinate files
echo "STEP 1. For each gene, find accordinate files"
while read geneSymbol geneRegEx; do
	file2screen="$PREFIX"*
	# screen items for each gene
	echo \>"$geneSymbol" >>output/$itemsForGene
	grep $geneRegEx $file2screen >>output/$itemsForGene
	# screen files for each gene
	echo \>"$geneSymbol" >>output/$filesForGene
	grep -l $geneRegEx $file2screen >>output/$filesForGene
done < $KEYGENES
echo "Done."


# 2. for each file, screen key genes
echo "STEP 2. For each file, screen key genes"
while read FILE; do
	while read geneSymbol geneRegEx; do
		grep $geneRegEx $FILE >>output/KG_"$FILE"
	done < $KEYGENES
done < $FILENAMES
echo "Done."


# 3. get visible results
cut -f 1,3,8,9  $itemsForGene | sed 's/:\w*//g' > $result #