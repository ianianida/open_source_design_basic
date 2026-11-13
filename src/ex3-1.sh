#!/bin/sh
# Integer arithmetic from two positional arguments.
set -eu

if [ "$#" -ne 2 ]; then
    printf '사용법: sh %s 정수1 정수2\n' "$0" >&2
    exit 1
fi
for number do
    if ! printf '%s\n' "$number" | grep -Eq '^[+-]?[0-9]+$'; then
        printf '오류: 정수 두 개를 입력하세요: %s\n' "$number" >&2
        exit 1
    fi
done

awk -v a="$1" -v b="$2" 'BEGIN {
    printf "%s + %s = %.0f\n", a, b, a + b
    printf "%s - %s = %.0f\n", a, b, a - b
    printf "%s * %s = %.0f\n", a, b, a * b
    if (b == 0) print "나눗셈: 0으로 나눌 수 없습니다."
    else printf "%s / %s = %.0f\n", a, b, int(a / b)
}'
