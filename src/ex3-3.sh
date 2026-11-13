#!/bin/sh
# Grade two or more scores. A is at least 90; all other valid scores are B.
set -eu

printf '%s' '과목 점수 두 개 이상을 공백으로 구분해 입력하세요: '
IFS= read -r line || exit 1
set -f
# Intentional word splitting converts the entered list to individual scores.
# shellcheck disable=SC2086
set -- $line
if [ "$#" -lt 2 ]; then
    printf '%s\n' '오류: 두 과목 이상의 점수를 입력하세요.' >&2
    exit 1
fi

printf '%s\n' "$@" | awk '
    {
        scores[NR] = $0
        if ($0 !~ /^([0-9]+([.][0-9]*)?|[.][0-9]+)$/ || $0 < 0 || $0 > 100) bad = 1
    }
    END {
        if (bad) { print "오류: 점수는 0부터 100까지의 숫자여야 합니다." > "/dev/stderr"; exit 1 }
        for (i = 1; i <= NR; i++) {
            grade = (scores[i] >= 90) ? "A" : "B"
            printf "%d번째 과목: %s점, 등급 %s\n", i, scores[i], grade
            sum += scores[i]
        }
        average = sum / NR
        printf "평균 점수: %.2f점\n평균 등급: %s\n", average, (average >= 90 ? "A" : "B")
    }
'
