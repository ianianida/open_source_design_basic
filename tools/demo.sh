#!/bin/sh
# One-shot demonstration in Ubuntu. Test data is created in a fresh temporary directory.
set -eu
repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
scratch=$(mktemp -d "${TMPDIR:-/tmp}/course-ex3.XXXXXXXX")
ln -s "$repo/src" "$scratch/src"
cd "$scratch"
run_dir="$scratch/logs"
mkdir "$run_dir"
wait_seconds=${EX3_CAPTURE_DELAY:-30}
case "$wait_seconds" in ''|*[!0-9]*) printf '%s\n' 'EX3_CAPTURE_DELAY는 초 단위 정수여야 합니다.' >&2; exit 1 ;; esac
public_mode=${EX3_PUBLIC:-0}
if [ "$public_mode" = 1 ]; then printf '\033]0;Ubuntu Shell Practice\007'; fi

# Redact only the logged-in username from displayed output for public reports.
# The underlying commands and exit codes remain unchanged.
hide_user() {
    if [ "$public_mode" = 1 ] && [ -n "${USER:-}" ]; then
        awk -v name="$USER" '
            {
                remaining = $0; output = ""
                while ((position = index(remaining, name)) > 0) {
                    output = output substr(remaining, 1, position - 1) "[사용자]"
                    remaining = substr(remaining, position + length(name))
                }
                print output remaining
            }
        '
    else cat
    fi
}

show_and_wait() {
    number=$1
    result=$2
    printf '\n실행 종료 코드: %s\n' "$result"
    if [ "$result" -ne 0 ]; then
        printf '%s\n' '오류가 있어 이 단계에서 멈췄습니다.'
        exit "$result"
    fi
    printf '\n[실행 결과 %s/10] 화면 확인을 위해 %s초간 기다립니다.\n' "$((number + 1))" "$wait_seconds"
    sleep "$wait_seconds"
}

clear_screen() { printf '\033[2J\033[H'; }
execute() {
    number=$1
    clear_screen
    printf '오픈소스기초설계 실습: ex3-%s.sh\n\n' "$number"
    if [ "$public_mode" = 1 ]; then printf '%s\n\n' '(공개용 화면: 사용자 이름만 가림)'; fi
    case "$number" in
        0)
            printf '%s\n' '$ sh src/ex3-0.sh'
            set +e; sh src/ex3-0.sh > "$run_dir/ex3-0.log" 2>&1; result=$?; set -e
            cat "$run_dir/ex3-0.log" | hide_user
            ;;
        1)
            printf '%s\n' '$ sh src/ex3-1.sh 12 5'
            set +e; sh src/ex3-1.sh 12 5 > "$run_dir/ex3-1.log" 2>&1; result=$?; set -e
            cat "$run_dir/ex3-1.log" | hide_user
            ;;
        2)
            printf '%s\n' '$ printf "2 3.5 -4\\n" | sh src/ex3-2.sh'
            set +e; printf '2 3.5 -4\n' | sh src/ex3-2.sh > "$run_dir/ex3-2.log" 2>&1; result=$?; set -e
            cat "$run_dir/ex3-2.log" | hide_user
            ;;
        3)
            printf '%s\n' '$ printf "90 89 91\\n" | sh src/ex3-3.sh'
            set +e; printf '90 89 91\n' | sh src/ex3-3.sh > "$run_dir/ex3-3.log" 2>&1; result=$?; set -e
            cat "$run_dir/ex3-3.log" | hide_user
            ;;
        4)
            printf '%s\n' '$ printf "1\\nMath\\n95\\n1\\nEnglish\\n85\\n2\\n3\\n4\\n5\\n" | sh src/ex3-4.sh'
            set +e; printf '1\nMath\n95\n1\nEnglish\n85\n2\n3\n4\n5\n' | sh src/ex3-4.sh > "$run_dir/ex3-4.log" 2>&1; result=$?; set -e
            printf '%s\n' '(실제 출력 중 성적과 평균에 해당하는 줄)'
            grep -E '성적을 추가했습니다|Math:|English:|평균 점수:|주의:|예시:|프로그램을 종료합니다' "$run_dir/ex3-4.log" | hide_user || :
            ;;
        5)
            printf '%s\n' '$ printf "1\\n2\\n3\\n4\\n5\\n" | sh src/ex3-5.sh'
            set +e; printf '1\n2\n3\n4\n5\n' | sh src/ex3-5.sh > "$run_dir/ex3-5.log" 2>&1; result=$?; set -e
            printf '%s\n' '(실제 출력 중 사용자, CPU, 메모리, 디스크 정보)'
            sed '/^[1-5]) /d; /^$/d' "$run_dir/ex3-5.log" | hide_user
            printf '\n%s\n' '$ sh src/ex3-5.sh -l src/ex3-1.sh'
            set +e; sh src/ex3-5.sh -l src/ex3-1.sh > "$run_dir/ex3-5-ls.log" 2>&1; result2=$?; set -e
            cat "$run_dir/ex3-5-ls.log" | hide_user
            if [ "$result2" -ne 0 ]; then result=$result2; fi
            ;;
        6)
            printf '%s\n' '$ sh src/ex3-6.sh files'
            set +e; sh src/ex3-6.sh files > "$run_dir/ex3-6.log" 2>&1; result=$?; set -e
            cat "$run_dir/ex3-6.log" | hide_user
            ;;
        7)
            printf '%s\n' '$ sh src/ex3-7.sh links'
            set +e; sh src/ex3-7.sh links > "$run_dir/ex3-7.log" 2>&1; result=$?; set -e
            cat "$run_dir/ex3-7.log" | hide_user
            ;;
        8)
            printf '%s\n' '$ sh src/ex3-8.sh Alice 2001-01-01' '$ sh src/ex3-8.sh Bob 2002-02-02' '$ cat DB.txt'
            set +e
            { sh src/ex3-8.sh Alice 2001-01-01 && sh src/ex3-8.sh Bob 2002-02-02 && cat DB.txt; } > "$run_dir/ex3-8.log" 2>&1
            result=$?
            set -e
            cat "$run_dir/ex3-8.log" | hide_user
            ;;
        9)
            if [ ! -f DB.txt ]; then sh src/ex3-8.sh Alice 2001-01-01 > /dev/null; fi
            printf '%s\n' '$ sh src/ex3-9.sh Alice' '$ sh src/ex3-9.sh Nobody'
            set +e
            { sh src/ex3-9.sh Alice && sh src/ex3-9.sh Nobody; } > "$run_dir/ex3-9.log" 2>&1
            result=$?
            set -e
            cat "$run_dir/ex3-9.log" | hide_user
            ;;
    esac
    show_and_wait "$number" "$result"
}

if [ "$#" -eq 0 ]; then set -- 0 1 2 3 4 5 6 7 8 9; fi
for number do
    case "$number" in [0-9]) execute "$number" ;; *) printf '잘못된 문제 번호: %s\n' "$number" >&2; exit 1 ;; esac
done
printf '\n%s\n' '선택한 실습을 완료했습니다.'
printf '전체 실행 기록: %s\n' "$run_dir"
