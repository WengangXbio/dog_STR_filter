# Simulation

### Simulating reads around STR loci with distinct copies
#### Load modules
```
module load igmm/apps/samtools/1.6
module load igmm/apps/BEDTools/2.27.1
module load igmm/apps/R/3.6.0
```
#### Take an example of three chromosomes (chr1, chr2, and chr22), CAT three chromosomes' STR bed files
```
cat RM2_chr*_singleton_Simple_repeat_tetran_adj.bed > RM2_singleton_Simple_repeat_tetran_adj.bed
```
#### Simulating reads with length 100bp, 125bp and 150bp
For 100bp reads:
```
./simulation_up100.sh RM2_singleton_Simple_repeat_tetran_adj.bed 0 > simulation_up_0.fasta
for k in $(seq 1 5)
do
./simulation_up100.sh RM2_singleton_Simple_repeat_tetran_adj.bed $k > simulation_up_$k.fasta
./simulation_down100.sh RM2_singleton_Simple_repeat_tetran_adj.bed $k > simulation_down_$k.fasta
done
```
For 125bp reads:
```
./simulation_up125.sh RM2_singleton_Simple_repeat_tetran_adj.bed 0 > simulation_up_0.fasta
for k in $(seq 1 5)
do
./simulation_up125.sh RM2_singleton_Simple_repeat_tetran_adj.bed $k > simulation_up_$k.fasta
./simulation_down125.sh RM2_singleton_Simple_repeat_tetran_adj.bed $k > simulation_down_$k.fasta
done
```
For 150bp reads:
```
./simulation_up150.sh RM2_singleton_Simple_repeat_tetran_adj.bed 0 > simulation_up_0.fasta
for k in $(seq 1 5)
do
./simulation_up150.sh RM2_singleton_Simple_repeat_tetran_adj.bed $k > simulation_up_$k.fasta
./simulation_down150.sh RM2_singleton_Simple_repeat_tetran_adj.bed $k > simulation_down_$k.fasta
done
```
#### Aligning generated reads against reference genome
```
cat  *.fasta > simulation.fasta
qsub bwa0.sh
```

### Mappability of reads with greater (or less) copies than reference genome
#### Count reads mapped on each STR locus, and generated figures
```
awk '{print $5,$3-$2+1}' RM2_singleton_Simple_repeat_tetran_adj.bed > str.length
bash estimation_count.sh RM2_singleton_Simple_repeat_tetran_adj.bed simulation.sorted.bam simulation.estimation_count
awk 'BEGIN{OFS="\t"} {print $1,$2}' simulation.estimation_count |awk -F "-X|X-|\t" '{print $1,$2,$4}' |awk '$2==$1 {print $1,$3}' > simulation.estimation_count.results
Rscript mappability.r
```
<img src="https://github.com/WengangXbio/dog_STR_filter/blob/dafdd04c96982f9757a1ae65c89b3dfc46c88d9f/2.%20Simulation/figures/Mappability.png" alt="Alt text" width="400" height="400"> 

### Detection of reads with greater (or less) copies than reference genome
```
awk '{print $5,$3-$2+1}'      RM2_singleton_Simple_repeat_tetran_adj.bed > str.length
bash estimation.sh RM2_singleton_Simple_repeat_tetran_adj.bed simulation.sorted.bam simulation.estimation_detection
awk -F "-X|X-|\t" '{print $1,$2,$4}' simulation.estimation_detection |awk '$2==$1 {print $1,$3}' > simulation.estimation_detection.results
Rscript detection_rate.r
```
<img src="https://github.com/WengangXbio/dog_STR_filter/blob/22f0247b08f548098f640fd94aa9ce06cd8728eb/2.%20Simulation/figures/Detection_rate_100.png" alt="Alt text" width="400" height="400"> <img src="https://github.com/WengangXbio/dog_STR_filter/blob/22f0247b08f548098f640fd94aa9ce06cd8728eb/2.%20Simulation/figures/Detection_rate_125.png" alt="Alt text" width="400" height="400"> <img src="https://github.com/WengangXbio/dog_STR_filter/blob/22f0247b08f548098f640fd94aa9ce06cd8728eb/2.%20Simulation/figures/Detection_rate_150.png" alt="Alt text" width="400" height="400">

