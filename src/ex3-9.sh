#!/bin/sh
# Search the name field written by ex3-8.sh in the current working directory.
set -eu
if [ "$#" -ne 1 ] || [ -z "$1" ]; then
    printf '사용법: sh %s 이름\n' "$0" >&2
    exit 1
fi
if [ ! -f DB.txt ]; then
    printf '%s\n' '오류: 현재 폴더에 DB.txt가 없습니다. ex3-8.sh를 먼저 실행하세요.' >&2
    exit 1
fi
awk -F '\t' -v name="$1" '
    $1 == name { printf "이름: %s, 정보: %s\n", $1, $2; found = 1 }
    END { if (!found) print "해당 이름을 찾을 수 없습니다." }
' DB.txt
