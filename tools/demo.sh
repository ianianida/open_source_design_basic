#!/bin/sh
# Run one assignment script interactively (no simulated prompts or piped input).
set -eu
repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo"

if [ "$#" -lt 1 ]; then
    printf '%s\n' '사용법: sh tools/demo.sh 번호 [스크립트 인자 ...]'
    printf '%s\n' '예: sh tools/demo.sh 2'
    printf '%s\n' '예: sh tools/demo.sh 1 12 5'
    printf '%s\n' '번호는 0부터 9까지입니다. 입력이 필요한 경우 직접 입력 후 Enter를 누르세요.'
    exit 0
fi

number=$1
shift
case "$number" in
    [0-9]) exec sh "src/ex3-$number.sh" "$@" ;;
    *) printf '%s\n' '오류: 번호는 0부터 9까지 입력하세요.' >&2; exit 1 ;;
esac
