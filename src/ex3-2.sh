#!/bin/sh
# Read real numbers one at a time and calculate y = x^2 / 2.
set -eu

printf '입력할 실수의 개수 (2개 이상): '
IFS= read -r count || exit 1
case "$count" in ''|*[!0-9]*) printf '%s\n' '오류: 2 이상의 정수를 입력하세요.' >&2; exit 1 ;; esac
if [ "$count" -lt 2 ]; then
    printf '%s\n' '오류: 실수는 2개 이상 입력해야 합니다.' >&2
    exit 1
fi

values_file=$(mktemp "${TMPDIR:-/tmp}/ex3-2.XXXXXXXX")
trap 'rm -f "$values_file"' EXIT HUP INT TERM

i=1
while [ "$i" -le "$count" ]; do
    printf '%s번째 실수 입력: ' "$i"
    IFS= read -r x || exit 1
    if ! awk -v x="$x" 'BEGIN { exit !(x ~ /^[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)$/) }'; then
        printf '%s\n' '오류: 올바른 실수를 입력하세요.' >&2
        exit 1
    fi
    printf '%s\n' "$x" >> "$values_file"
    i=$((i + 1))
done

printf '\n%s\n' '계산 결과 (y = x^2 / 2)'
awk '{ printf "x = %s, y = %.6f\n", $0, $0 * $0 / 2 }' "$values_file"
