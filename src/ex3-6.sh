#!/bin/sh
# Create five files, compress them, and extract them into a new directory.
set -eu
if [ "$#" -ne 1 ] || [ -z "$1" ]; then
    printf '사용법: sh %s 폴더이름\n' "$0" >&2
    exit 1
fi
target=$1
if [ -d "$target" ]; then printf '기존 폴더 사용: %s\n' "$target"
else mkdir -p -- "$target"; printf '폴더 생성: %s\n' "$target"; fi

# A unique directory avoids overwriting any existing files or archives.
work_dir=$(mktemp -d "$target/ex3-6.XXXXXXXX")
for i in 0 1 2 3 4; do printf '파일 %s의 내용\n' "$i" > "$work_dir/file$i.txt"; done
tar -czf "$work_dir/files.tar.gz" -C "$work_dir" file0.txt file1.txt file2.txt file3.txt file4.txt
mkdir "$work_dir/extracted"
tar -xzf "$work_dir/files.tar.gz" -C "$work_dir/extracted"
printf '압축 파일: %s/files.tar.gz\n압축 해제 폴더: %s/extracted\n' "$work_dir" "$work_dir"
printf '%s\n' '압축 해제된 파일:'
ls -1 "$work_dir/extracted"
