#!/bin/bash

# 检查参数数量
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

# 读取文件内容
while read -r col1 col2 col3 col4 col5; do
    if [[ -n "$col2" && -n "$col3" && -n "$col4" ]]; then
        # 计算结果
        result=$(( (col3 - col2 +1) / ${#col4} * ${#col4} ))
        new_col3=$((col2 + result -1))
        # 打印结果
        echo -e "$col1\t$col2\t$new_col3\t$col4\t$col5"
    fi
done < "$1"
