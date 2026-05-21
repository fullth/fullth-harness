# 산출물 체크리스트

프로젝트를 끝내기 전 아래를 모두 만족해야 한다. CI 가 자동 검증한다.

## 공통

- [ ] `PROBLEM.md` — placeholder 없이 채워짐
- [ ] `DESIGN.md` — placeholder 없이 채워짐
- [ ] `RETRO.md` — placeholder 없이 채워짐, "하네스 개선점" 포함
- [ ] `README.md` — 실행 방법 포함
- [ ] 외부 데이터 의존 시 — 합법성(공식 대안/robots/민사 리스크) 판단을 문서에 기록

## Nest 프로젝트 (`--type nest`)

- [ ] `npm run build` 성공
- [ ] `npm test` 통과 (정상·실패·경계 케이스 포함)
- [ ] `docker build` 성공

## CLI 프로젝트 (`--type cli`)

- [ ] `shellcheck` 통과 (CI 에서 `bin/*` `scripts/*.sh` `scripts/lib/*.sh`)
- [ ] `bats tests/` 통과 (정상·실패·경계 케이스 포함, ASCII 테스트명)
- [ ] mock 픽스처로 외부 의존 없이 CI 가 도는 것을 확인

## TypeScript CLI 프로젝트 (`--type ts-cli`)

- [ ] `npm run build` 성공
- [ ] `npm test` 통과 (정상·실패·경계 케이스 포함)
- [ ] 순수 로직은 `lib/` 로 분리, 네트워크 없이 픽스처로 테스트

## 회고 후

- [ ] `RETRO.md`의 "하네스 개선점"을 `retro-harvest`로 처리
- [ ] 하네스 변경 시 `CHANGELOG.md` 갱신
