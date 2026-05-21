# 프로젝트 진행 순서

새 세션에서 한 프로젝트를 처음부터 끝까지 진행하는 순서다.

1. **하네스 최신화** — 하네스 저장소를 pull 한다. 최신 스킬·템플릿을
   확보한다.
2. **아이디어 선택** — `backlog.md`에서 오늘 만들 프로젝트 하나를 고른다.
3. **외부 데이터 의존 점검** — 외부 사이트/비공식 API 데이터에 의존한다면
   코드 전에 합법성을 확인한다: 공식·공공 API 대안 우선, robots.txt,
   ToS·민사(부정경쟁방지법) 리스크. `web-scrape-provider` 스킬의 "0. 합법성"
   을 따르고 판단을 `PROBLEM.md`/`DESIGN.md`에 한 줄 남긴다.
4. **골격 생성** — `./scripts/new-project.sh <name> [--type nest|cli|ts-cli]` 실행.
   `nest` 는 NestJS + Docker + ci, `cli` 는 bash CLI + shellcheck/bats,
   `ts-cli` 는 TypeScript CLI(commander+zod+vitest) + ci 가 들어온다. 날짜
   prefix 폴더에 생성되고 별도 저장소가 연결된다.
5. **문제정의** — `problem-framing` 스킬로 `PROBLEM.md`를 채운다.
6. **설계** — `DESIGN.md`에 접근·결정·trade-off 를 적는다.
7. **구현** — 유형별 스킬 컨벤션을 따라 구현하고 테스트를 함께 작성한다.
   nest → `nest-scaffold`, bash → `cli-scaffold`, TypeScript → `ts-cli-scaffold`.
   웹 데이터 수집은 `web-scrape-provider`, 폰/원격 실행은
   `serverless-bot-deploy` 를 함께 쓴다.
8. **CI 확인** — 빌드·테스트·문서검증(유형별)이 통과하는지 본다.
9. **회고** — `RETRO.md`를 채운다. "하네스 개선점" 란을 반드시 적는다.
10. **되먹임** — `retro-harvest` 스킬로 회고를 하네스에 반영한다.
