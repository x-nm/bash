# annotation
# col 2, 10 for deseq former.
# 2016.10.08 by xnm

USAGE="USAGE: ./$0 <file prefix for operation instructions, as label whthout up/down.txt> "

if [ $# -ne 1 ]; then
        echo $USAGE
        exit 1
fi

# Data&Scripts preparation
label=$1 # the 1st arg is the operation file
x_ann=Ann.py
ann_symbol=gene_id2symbol.txt
ann_name=gene_symbol2name.txt

if [ ! -d output ]; then
	mkdir output
fi


# 2. annotation: gene symbol
echo "STEP2: GENE SYMBOL ANNOTATION"
python $x_ann "$label"_up.txt $ann_symbol 2 sy
python $x_ann "$label"_down.txt $ann_symbol 2 sy
# generates two files: DEG_$G1$G2_up/down_sy.txt;
# 3. annotation: gene name
echo "STEP3: GENE NAME ANNOTATION"
python $x_ann "$label"_up_sy.txt $ann_name 10 nm
python $x_ann "$label"_down_sy.txt $ann_name 10 nm
# generates two files: DEG_$G1$G2_up/down_sy_nm.txt;
# 4. cut -> list
echo "STEP4: CUT TO LIST"
cut -f 8,9 "$label"_up_sy_nm.txt >DL_"$label"_up.txt
cut -f 8,9 "$label"_down_sy_nm.txt >DL_"$label"_down.txt
# generates two files: DL_$G1$G2_up/down.txt, 
# with format "gene symbol TAB gene name"
# 5. DEG counting
echo "STEP5: DEG counting"
# usage of function: count up
DEG_count(){
	ct=`wc -l "$label"_$1.txt`
	ct=${ct% *} #forward cut-out, as in some wc there will be filename after count
	echo "$label"_$1: $((ct-1))
}
DEG_count up >> DEG_count.txt
DEG_count down >> DEG_count.txt
# 6. redundancy removing & move into output folder
echo "STEP6: ENDING"
rm "$label"_up.txt
rm "$label"_down.txt
rm "$label"_up_sy.txt
rm "$label"_down_sy.txt
mv "$label"_up_sy_nm.txt "$label"_up.txt
mv "$label"_down_sy_nm.txt "$label"_down.txt
# left 4 txt files: 2 DEG with ann; 2 DL(DEG list)
mv *"$label"* output 