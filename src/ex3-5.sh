#!/bin/sh
# Both PDF sections are labeled ex3-5. Keep both functions in one file.
set -eu

list_files() {
    ls "$@"
}

# Arguments supplied to the script are forwarded as ls options/arguments.
if [ "$#" -gt 0 ]; then
    printf '%s\n' '내부 함수에서 전달된 인자로 ls를 실행합니다.'
    list_files "$@"
    exit
fi

while :; do
    printf '\n%s\n' '1) 사용자 정보' '2) CPU 사용률' '3) 메모리 사용량' '4) 디스크 사용량' '5) 종료'
    printf '%s' '메뉴 선택: '
    IFS= read -r choice || break
    case "$choice" in
        1) id ;;
        2) LC_ALL=C top -b -n 1 | awk '/^%?Cpu\(s\):/ { print; found = 1 } END { if (!found) print "CPU 정보를 확인할 수 없습니다." }' ;;
        3) free -h ;;
        4) df -h . ;;
        5) printf '%s\n' '프로그램을 종료합니다.'; break ;;
        *) printf '%s\n' '1부터 5까지 선택하세요.' ;;
    esac
done
