#$ -N bwa0
#$ -cwd
#$ -l h_rt=99:00:00
#$ -R y
#$ -l h_vmem=4G
#$ -pe sharedmem 10
#$ -w n
#$ -P roslin_schoenebeck_group
. /etc/profile.d/modules.sh

module load roslin/samtools/1.10
export PATH=$PATH:/home/s1874451/schoenebeck_group/WENGANG/WZ_software/bwa-mem2

sample_name=simulation
ref_fa='/home/s1874451/schoenebeck_group/WENGANG/Liuyang_cnv/ROS_Cfam/ROS_Cfam1.fa'

bwa-mem2 mem -R "@RG\tID:id_${sample_name}\tSM:${sample_name}\tLB:lib1" -t 10 ${ref_fa} simulation.fasta | samtools sort -o simulation.sorted.bam
samtools index simulation.sorted.bam