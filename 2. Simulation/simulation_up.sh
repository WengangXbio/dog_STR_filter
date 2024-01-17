#!/bin/bash
# 检查是否提供了足够的参数
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <dataname> <bias>"
    exit 1
fi

# 提取参数
dataname=$1
bias=$2


# 将数据按行分割
IFS=$'\n'

while read -r line; do
# 提取字段
name=$(echo "$line" | awk '{print $5}')
pattern=$(echo "$line" | awk '{print $4}')
length=${#pattern}
start=$(echo "$line" | awk '{print $2}')
end=$(echo "$line" | awk '{print $3}')
# 计算复制次数
copy=$(( (end - start + 1) / length + bias))

# 生成随机数和前缀、后缀的区间
rand=$(shuf -i 15-50 -n 10)
for random_number in $rand; do
preffix_start=$((start-random_number))
preffix_end=$((start-1))
suffix_start=$((end))
suffix_end=$((end+95))
# 使用 bedtools getfasta 获取前缀和后缀的序列
preffix=$(echo -e "chr22\t$preffix_start\t$preffix_end" | bedtools getfasta -fi chr22.fasta -bed - |tail -n +2)
str=$(awk -v copy="$copy" -v pattern="$pattern" 'BEGIN { for (i=1; i<=copy; i++) printf pattern }')
suffix=$(echo -e "chr22\t$suffix_start\t$suffix_end" | bedtools getfasta -fi chr22.fasta -bed - |tail -n +2)
# 生成文件并输出结果 
seed=$((RANDOM % 90000 + 10000))
echo ">$name-$seed-$bias"
echo "$preffix$str$suffix" | cut -c 1-125
done
done < "$dataname"
