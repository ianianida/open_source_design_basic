# 오픈소스기초설계 — 셸 프로그래밍 실습

Ubuntu 환경에서 리눅스 명령어와 셸 스크립트를 활용한 실습 과제입니다.

## 저장소 구성

- `src/`: `ex3-0.sh` ~ `ex3-9.sh` (총 10개)
- `doc/`: [셸프로그래밍(20261680,김이안).docx](doc/%EC%85%B8%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D%2820261680%2C%EA%B9%80%EC%9D%B4%EC%95%88%29.docx) — 문제별 실행 결과와 소스코드

## 실행 방법

Ubuntu 터미널에서 저장소 최상위 폴더를 기준으로 실행합니다.

```sh
sh src/ex3-0.sh
sh src/ex3-1.sh 12 5
sh src/ex3-2.sh
sh src/ex3-3.sh
sh src/ex3-4.sh
sh src/ex3-5.sh
sh src/ex3-5.sh -l src/ex3-1.sh
sh src/ex3-6.sh files
sh src/ex3-7.sh links
sh src/ex3-8.sh Alice 2001-01-01
sh src/ex3-8.sh Bob 2002-02-02
cat DB.txt
sh src/ex3-9.sh Ali
```

`ex3-2.sh`와 `ex3-3.sh`는 값의 개수를 입력한 후 각 값을 한 번씩 입력받습니다. `ex3-4.sh`와 `ex3-5.sh`는 메뉴를 반복 출력하며 선택을 입력받습니다.

## 참고 사항

- 실습 PDF의 4쪽과 5쪽에 서로 다른 요구사항이 모두 `ex3-5.sh`로 기재되어 있어, 시스템 상태 확인 메뉴와 명령 인자 전달 함수를 한 파일에 구현했습니다.
- GPA 환산 기준은 실습 자료에 명시되지 않아 `ex3-4.sh`에 **4.5점 만점 예시 기준**을 적용하고 그 사실을 출력합니다.
- `ex3-8.sh`와 `ex3-9.sh`는 현재 작업 디렉터리의 `DB.txt`를 사용합니다. 예시 인적사항을 사용합니다.
