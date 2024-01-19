#!/bin/bash
module load igmm/apps/samtools/1.6
module load igmm/apps/BEDTools/2.27.1
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <str_bed> <bam> <output>"
    exit 1
fi
bed=$1
bam=$2
result_txt=$3
echo > $result_txt
for str in `cut -f5 $bed`  ; do
chr=$(awk -v pattern="$str" '$5 == pattern {print$1}' $bed)
start=$(awk -v pattern="$str" '$5 == pattern {print$2}' $bed)
end=$(awk -v pattern="$str" '$5 == pattern {print$3}' $bed)
pattern=$(awk -v pattern="$str" '$5 == pattern {print$4}' $bed)
new_chr=$(awk -v chr="$chr" '$1==chr {print$2}' chr.table)
flank_start=$((start - 10))
flank_end=$((end + 10))
samtools view $bam $new_chr:$flank_start-$flank_end |cut -f1 |awk -v a="$str" '{print a,$0}' > temp_result
cat $result_txt temp_result > temp_result2
mv temp_result2 $result_txt
done

