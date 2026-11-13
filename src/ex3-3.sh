#!/bin/sh
# Read scores one by one, then calculate the A/B grade of each and their average.
set -eu

printf '입력할 과목 수 (2개 이상): '
IFS= read -r count || exit 1
case "$count" in ''|*[!0-9]*) printf '%s\n' '오류: 2 이상의 정수를 입력하세요.' >&2; exit 1 ;; esac
if [ "$count" -lt 2 ]; then
    printf '%s\n' '오류: 과목은 2개 이상 입력해야 합니다.' >&2
    exit 1
fi

scores_file=$(mktemp "${TMPDIR:-/tmp}/ex3-3.XXXXXXXX")
trap 'rm -f "$scores_file"' EXIT HUP INT TERM

i=1
while [ "$i" -le "$count" ]; do
    printf '%s번째 과목 점수 (0~100): ' "$i"
    IFS= read -r score || exit 1
    if ! awk -v s="$score" 'BEGIN { exit !(s ~ /^([0-9]+([.][0-9]*)?|[.][0-9]+)$/ && s >= 0 && s <= 100) }'; then
        printf '%s\n' '오류: 0에서 100 사이의 점수를 입력하세요.' >&2
        exit 1
    fi
    printf '%s\n' "$score" >> "$scores_file"
    i=$((i + 1))
done

printf '\n%s\n' '성적 결과'
awk '
    {
        grade = ($1 >= 90) ? "A" : "B"
        printf "%d번째 과목: %s점, 등급 %s\n", NR, $1, grade
        sum += $1
    }
    END {
        average = sum / NR
        printf "평균 점수: %.2f점\n평균 등급: %s\n", average, (average >= 90 ? "A" : "B")
    }
' "$scores_file"
