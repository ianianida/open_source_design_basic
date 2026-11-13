#!/bin/sh
# Compute y = x^2 / 2 for two or more real-valued inputs.
set -eu

printf '%s' '실수 두 개 이상을 공백으로 구분해 입력하세요: '
IFS= read -r line || exit 1
set -f
# Intentional word splitting converts the entered list to individual values.
# shellcheck disable=SC2086
set -- $line
if [ "$#" -lt 2 ]; then
    printf '%s\n' '오류: 두 개 이상의 값을 입력하세요.' >&2
    exit 1
fi

printf '%s\n' "$@" | awk '
    { values[NR] = $0; if ($0 !~ /^[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)$/) bad = 1 }
    END {
        if (bad) { print "오류: 입력값은 실수여야 합니다." > "/dev/stderr"; exit 1 }
        for (i = 1; i <= NR; i++) printf "x = %s, y = %.6f\n", values[i], values[i] * values[i] / 2
    }
'
