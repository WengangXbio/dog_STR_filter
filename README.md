# dog DNA profiling project
## 1. Candidate STR selection (taking an example of chromosome 22)
### First, download the RepeatMasker result from [NCBI](https://www.ncbi.nlm.nih.gov/nuccore/NC_051826.1?report=graph) and name it as "RM2_chr22.bed".
### Second, filter "Simple repeats" that have no other transposable elements in 30bp of flanking regions.
```
module load igmm/apps/BEDTools/2.27.1
grep  Simple_repeat RM2_chr22.bed > RM2_chr22_simplerepeat.bed
grep -v  Simple_repeat RM2_chr22.bed > RM2_chr22_others.bed
bedtools closest -a RM2_chr22_simplerepeat.bed -b RM2_chr22_others.bed -d > RM2_chr22_simplerepeat.closest
awk 'BEGIN{OFS="\t"} $13>=30 {print $1,$2-30,$3+30,$1"-"$2-30"-"$3+30}' RM2_chr22_simplerepeat.closest > RM2_chr22_simplerepeat_nonTE_flanking30.bed
bedtools intersect -a RM2_chr22_simplerepeat_nonTE_flanking30.bed -b RM2_chr22_simplerepeat_nonTE_flanking30.bed -wo |awk '$4!=$8 {print $4}' > RM2_chr22_simplerepeat_overlap.name
awk -f vlookup.awk RM2_chr22_simplerepeat_overlap.name RM2_chr22_simplerepeat_nonTE_flanking30.bed |awk 'BEGIN{OFS="\t"} $5=="KP" {print $1,$2,$3,$4}' - > RM2_chr22_simplerepeat_nonTE_flanking30_nonoverlap.bed
bedtools merge -i RM2_chr22_simplerepeat_nonTE_flanking30_nonoverlap.bed |awk 'BEGIN{OFS="\t"} {print $1,$2,$3,$1"-"$2"-"$3}' > RM2_chr22_simplerepeat_nonTE_flanking30_nonoverlap0.bed
bedtools getfasta -fi chr22.fasta -bed RM2_chr22_simplerepeat_nonTE_flanking30_nonoverlap0.bed -name > RM2_chr22_simplerepeat_nonTE_flanking30_nonoverlap0.fasta
```
### Third, run [RepeatMasker](https://www.repeatmasker.org/cgi-bin/WEBRepeatMasker) for simple repeat sequences generated. The suffix of output files is ".out"
### Forth, filter simple repeats that has no variants within, and singleton unit is 3-5 bp in length.
```
cat RM2_RM2_chr22_simplerepeat_nonTE_flanking30_nonoverlap*.out > RM2_chr22.out
awk '{print $5}' RM2_chr22.out |sort |uniq -c |awk '$1==1 {print $2}' > RM2_chr22_singleton.name
awk -f vlookup1.awk RM2_chr22_singleton.name RM2_chr22.out |grep KP |grep Simple_repeat > RM2_chr22_singleton_Simple_repeat.out
awk '{print $10}' RM2_chr22_singleton_Simple_repeat.out |awk '{print length, $0}' |awk '$1<=8 && $1>=6 {print $2}' > RM2_chr22_singleton_Simple_repeat.repeats
awk -f vlookup2.awk RM2_chr22_singleton_Simple_repeat.repeats RM2_chr22_singleton_Simple_repeat.out |awk '$17=="KP"' > RM2_chr22_singleton_Simple_repeat_tetran.out
awk '$2=="0.0" && $3=="0.0" && $4=="0.0" && $6>30 {print $5,$6,$7,$10}' RM2_chr22_singleton_Simple_repeat_tetran.out |awk -F'[ -]' 'BEGIN{OFS="\t"} {print $1,$2+$4,$2+$5,$6}' |awk '$3-$2>15 && $3-$2<100' |sort -k2,2n |awk 'BEGIN{OFS="\t"} {print $0,$1"-STR"NR}' > RM2_chr22_singleton_Simple_repeat_tetran.bed
```
