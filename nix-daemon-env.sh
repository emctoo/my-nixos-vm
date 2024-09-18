#!/usr/bin/env bash

set -e

# 获取 nix-daemon 的环境变量
env_output=$(systemctl show nix-daemon -p Environment)
echo $env_output
echo ""

# 移除开头的 "Environment=" 字符串
env_output=${env_output#Environment=}

# 用 -d' ' 来指定空格作为分隔符。
# -f2- 选择从第二个字段到最后的所有字段，这样就去掉了开头的 "Environment=" 部分。
# env_output=$(systemctl show nix-daemon -p Environment | cut -d' ' -f2-)

# 初始化数组
declare -a env_array
declare -a path_array

# 遍历并处理每个环境变量
IFS=' ' read -ra temp_array <<<"$env_output"
for var in "${temp_array[@]}"; do
  if [[ $var == PATH=* ]]; then
    # 处理 PATH 变量
    IFS=':' read -ra path_array <<<"${var#PATH=}"
  else
    # 处理其他环境变量
    env_array+=("$var")
  fi
done

# 打印环境变量（除 PATH 外）
echo "Environment variables:"
for var in "${env_array[@]}"; do
  echo "$var"
done

# 打印 PATH 内容
echo -e "\nPATH entries:"
for entry in "${path_array[@]}"; do
  echo "$entry"
done

# 输出统计信息
echo -e "\nTotal environment variables (excluding PATH): ${#env_array[@]}"
echo "Total PATH entries: ${#path_array[@]}"
