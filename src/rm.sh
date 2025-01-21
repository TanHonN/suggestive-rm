#!/bin/bash
# 保护目录正则模式，所匹配的目录不允许被删除。
protected_dir_pattern="(\
/|/bin|/boot|/dev|/etc|/home|/lib|/lib64|/media|/mnt|\
/opt|/proc|/root|/run|/sbin|/srv|/sys|/tmp|/usr|/var|\
/home/docker/data\.bak.*|\
/home/docker/config\.bak.*\
)"
# 从参数中提取出路径，并将其转换为绝对路径。
paths=()
for arg in "$@"; do
  if [[ ! ("$arg" =~ ^--?.*$) ]]; then
    path=$(realpath -m "$arg")
    paths+=("$path")
  fi
done
# 逐目录检查，如果目标路径匹配到保护目录正则模式，则输出警告信息，并退出。
for path in "${paths[@]}"; do
  if [[ "$path" =~ ^$protected_dir_pattern/?$ ]]; then
    echo -e "\033[33m/usr/local/bin/rm: You are trying to delete the important directory \"$path\", which is a dangerous action.\nThis message comes from bash script \"/usr/local/bin/rm\", which is an override command for \"rm\", to avoid deleting system file accidentally.\033[0m"
    exit 1
  fi
done
# 如果删除命令的调用者不是用户，则直接调用删除命令。
p_name=$(ps -o comm= -p $PPID)
if [[ ! ("$p_name" =~ ^sh|bash|zsh|sudo$) ]]; then
  /bin/rm "$@"
else
  # 如果删除命令的调用者是用户，则在删除前计算并显示要删除文件的总大小，并询问是否确认删除。通过显示大小来警示命令执行者，降低其误删的可能性。
  /usr/bin/du -hs "${paths[@]}"
  read -rp $'\033[33m/usr/local/bin/rm: Above are the size of the files to be removed, are you sure to remove them? (y/n) \033[0m' is_remove
  if [[ "$is_remove" == "y" ]]; then
    /bin/rm "$@"
  fi
fi
