#!/bin/sh
# Create five files and working relative symbolic links in named subfolders.
set -eu
if [ "$#" -ne 1 ] || [ -z "$1" ]; then
    printf '사용법: sh %s 폴더이름\n' "$0" >&2
    exit 1
fi
mkdir -p -- "$1"
work_dir=$(mktemp -d "$1/ex3-7.XXXXXXXX")
for i in 0 1 2 3 4; do
    printf '파일 %s의 내용\n' "$i" > "$work_dir/file$i.txt"
    mkdir "$work_dir/file$i"
    ln -s "../file$i.txt" "$work_dir/file$i/file$i.txt"
done
printf '작업 폴더: %s\n' "$work_dir"
for i in 0 1 2 3 4; do ls -l "$work_dir/file$i/file$i.txt"; done
