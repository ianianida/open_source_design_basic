#!/bin/sh
# Grade menu. The GPA thresholds below are a clearly labeled example only.
set -eu
score_file=$(mktemp "${TMPDIR:-/tmp}/ex3-4.XXXXXXXX")
trap 'rm -f "$score_file"' EXIT HUP INT TERM

while :; do
    printf '\n%s\n' '===================' '1) 과목 성적 추가' '2) 입력된 모든 점수 보기' '3) 평균 점수 확인' '4) 평균 등급 (GPA) 변환' '5) 종료' '==================='
    printf '%s' '메뉴 선택: '
    IFS= read -r choice || break
    case "$choice" in
        1)
            printf '%s' '과목명: '
            IFS= read -r subject || break
            printf '%s' '점수 (0~100): '
            IFS= read -r score || break
            if [ -z "$subject" ] || ! awk -v s="$score" 'BEGIN { exit !(s ~ /^([0-9]+([.][0-9]*)?|[.][0-9]+)$/ && s >= 0 && s <= 100) }'; then
                printf '%s\n' '오류: 과목명과 0~100 사이 점수를 입력하세요.'
                continue
            fi
            printf '%s\t%s\n' "$subject" "$score" >> "$score_file"
            printf '%s\n' '성적을 추가했습니다.'
            ;;
        2)
            if [ ! -s "$score_file" ]; then printf '%s\n' '입력된 성적이 없습니다.'; continue; fi
            awk -F '\t' '{ printf "%d) %s: %s점\n", NR, $1, $2 }' "$score_file"
            ;;
        3)
            if [ ! -s "$score_file" ]; then printf '%s\n' '입력된 성적이 없습니다.'; continue; fi
            awk -F '\t' '{ sum += $2 } END { printf "평균 점수: %.2f점\n", sum / NR }' "$score_file"
            ;;
        4)
            if [ ! -s "$score_file" ]; then printf '%s\n' '입력된 성적이 없습니다.'; continue; fi
            awk -F '\t' '
                { sum += $2 }
                END {
                    average = sum / NR
                    if (average >= 95) { grade = "A+"; gpa = 4.5 }
                    else if (average >= 90) { grade = "A0"; gpa = 4.0 }
                    else if (average >= 85) { grade = "B+"; gpa = 3.5 }
                    else if (average >= 80) { grade = "B0"; gpa = 3.0 }
                    else if (average >= 75) { grade = "C+"; gpa = 2.5 }
                    else if (average >= 70) { grade = "C0"; gpa = 2.0 }
                    else if (average >= 65) { grade = "D+"; gpa = 1.5 }
                    else if (average >= 60) { grade = "D0"; gpa = 1.0 }
                    else { grade = "F"; gpa = 0.0 }
                    print "안내: GPA 환산 기준이 지정되지 않아 4.5 만점 예시 기준을 적용했습니다."
                    print "예시: 95 A+(4.5), 90 A0(4.0), 85 B+(3.5), 80 B0(3.0), 75 C+(2.5), 70 C0(2.0), 65 D+(1.5), 60 D0(1.0), 그 외 F(0.0)"
                    printf "평균 점수: %.2f점, 평균 등급: %s, GPA: %.1f / 4.5\n", average, grade, gpa
                }
            ' "$score_file"
            ;;
        5) printf '%s\n' '프로그램을 종료합니다.'; break ;;
        *) printf '%s\n' '1부터 5까지 선택하세요.' ;;
    esac
done
