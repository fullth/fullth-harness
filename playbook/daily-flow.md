# 프로젝트 진행 순서

새 세션에서 한 프로젝트를 처음부터 끝까지 진행하는 순서다.

1. **하네스 최신화** — 하네스 저장소를 pull 한다. 최신 스킬·템플릿을
   확보한다.
2. **아이디어 선택** — `backlog.md`에서 오늘 만들 프로젝트 하나를 고른다.
3. **골격 생성** — `./scripts/new-project.sh <name> [--type nest|cli]` 실행.
   기본 `nest` 는 NestJS + Docker + ci 가 들어오고, `cli` 는 bash CLI +
   shellcheck/bats CI 가 들어온다. 날짜 prefix 폴더에 생성되고 별도
   저장소가 연결된다.
4. **문제정의** — `problem-framing` 스킬로 `PROBLEM.md`를 채운다.
5. **설계** — `DESIGN.md`에 접근·결정·trade-off 를 적는다.
6. **구현** — `nest-scaffold` 스킬의 컨벤션을 따라 구현하고 테스트를
   함께 작성한다.
7. **CI 확인** — 빌드·테스트·문서검증·docker build 가 통과하는지 본다.
8. **회고** — `RETRO.md`를 채운다. "하네스 개선점" 란을 반드시 적는다.
9. **되먹임** — `retro-harvest` 스킬로 회고를 하네스에 반영한다.
