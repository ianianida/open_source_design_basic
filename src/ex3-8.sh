#!/bin/sh
# Use DB.txt in the current working directory. Default is append.
set -eu
mode=append
if [ "${1-}" = '--new' ]; then mode=new; shift; fi
if [ "$#" -lt 2 ] || [ -z "$1" ]; then
    printf '사용법: sh %s [--new] 이름 생일_또는_전화번호\n' "$0" >&2
    exit 1
fi
name=$1
shift
information=$*
database=DB.txt
if [ -L "$database" ]; then printf '%s\n' '오류: DB.txt가 심볼릭 링크이므로 수정하지 않습니다.' >&2; exit 1; fi
if [ -e "$database" ] && [ ! -f "$database" ]; then printf '%s\n' '오류: DB.txt가 일반 파일이 아닙니다.' >&2; exit 1; fi

if [ "$mode" = new ]; then
    if [ -e "$database" ]; then
        printf '%s' '기존 DB.txt를 지우고 새로 작성할까요? [y/N]: '
        IFS= read -r answer || exit 1
        case "$answer" in y|Y) ;; *) printf '%s\n' '취소했습니다.'; exit 0 ;; esac
    fi
    printf '%s\t%s\n' "$name" "$information" > "$database"
    printf '%s\n' 'DB.txt를 새로 작성했습니다.'
else
    printf '%s\t%s\n' "$name" "$information" >> "$database"
    printf '%s\n' 'DB.txt에 정보를 추가했습니다.'
fi
