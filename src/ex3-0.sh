#!/bin/sh
# Register a variable in the Bash startup file and demonstrate its lifetime.
set -eu

bashrc="$HOME/.bashrc"
entry='export MYENV="Hello Shell"'

if [ -e "$bashrc" ] && [ ! -f "$bashrc" ]; then
    printf '%s\n' '오류: ~/.bashrc가 일반 파일이 아닙니다.' >&2
    exit 1
fi
if [ -L "$bashrc" ]; then
    printf '%s\n' '오류: ~/.bashrc가 심볼릭 링크이므로 자동 수정하지 않습니다.' >&2
    exit 1
fi
if [ -f "$bashrc" ] && grep -Fxq "$entry" "$bashrc"; then
    printf '%s\n' '이미 ~/.bashrc에 같은 환경변수가 등록되어 있습니다.'
elif [ -f "$bashrc" ] && grep -Eq '^[[:space:]]*(export[[:space:]]+)?MYENV=' "$bashrc"; then
    printf '%s\n' '오류: ~/.bashrc에 다른 MYENV 설정이 이미 있습니다. 확인 후 실행하세요.' >&2
    exit 1
else
    if [ -f "$bashrc" ] && [ ! -e "$bashrc.ex3-0.backup" ]; then
        cp -p "$bashrc" "$bashrc.ex3-0.backup"
        printf '%s\n' '기존 ~/.bashrc를 ~/.bashrc.ex3-0.backup에 보관했습니다.'
    fi
    printf '\n# ex3-0: shell programming assignment\n%s\n' "$entry" >> "$bashrc"
    printf '%s\n' '~/.bashrc에 환경변수를 등록했습니다.'
fi

# Interactive Bash reads ~/.bashrc. The nested process checks export inheritance.
bash --noprofile -ic '
    printf "새 Bash의 MYENV: %s\n" "${MYENV-<없음>}"
    printf "자식 셸의 MYENV: "
    sh -c '\''printf "%s\n" "${MYENV-<없음>}"'\''
    unset MYENV
    printf "해제 후 자식 셸의 MYENV: "
    sh -c '\''printf "%s\n" "${MYENV-<없음>}"'\''
'
printf '%s\n' '참고: unset은 해당 셸에만 적용됩니다. 새 Bash는 .bashrc를 다시 읽습니다.'
