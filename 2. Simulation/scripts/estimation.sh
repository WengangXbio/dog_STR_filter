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
f_start=$((start - 16))
f_end=$((start - 1))
r_start=$end
r_end=$((end + 15))
fseq=$(echo -e "$new_chr\t$f_start\t$f_end" | bedtools getfasta -fi ROS_Cfam1.fa -bed - |tail -n +2)
rseq=$(echo -e "$new_chr\t$r_start\t$r_end" | bedtools getfasta -fi ROS_Cfam1.fa -bed - |tail -n +2)
samtools view $bam $new_chr:$flank_start-$flank_end |cut -f1,10 |grep "$fseq" | grep "$rseq" > reads

for readid in `cut -f1 reads`  ; do
sequence=$(awk -v reads="$readid" '$1 == reads {print$2}' reads |awk -F "${fseq}" '{print $2}' |awk -F "${rseq}" '{print $1}')
length=$(expr length "$pattern")
copy_pattern=$(echo "$sequence" | grep -o "$pattern" | wc -l)
copy_length=$(printf "%.0f" $(echo "scale=2; ${#sequence} / $length" | bc))
echo -e "$str\t$readid\t$pattern\t$copy_pattern\t$copy_length" > temp_result
cat $result_txt temp_result > temp_result2
mv temp_result2 $result_txt
done
done
rm temp_result reads
