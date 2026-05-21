# Changelog

하네스의 변경 이력. 스킬·템플릿·플레이북이 바뀔 때마다 한 항목씩 남긴다.

## [0.1.4] - 2026-05-21

### Added

- `templates/ts-cli/` — TypeScript CLI 골격(commander + zod + tsx + vitest, `lib/` 분리). 외부 API/웹 데이터를 다루는 일회성 요청-응답 도구용. (stay-finder 회고 반영)
- `templates/ci/ts-cli-ci.yml` — docs / build-test 2 잡 CI (docker 없음).
- `skills/ts-cli-scaffold/SKILL.md` — TS CLI 컨벤션·골격·테스트. bash `cli-scaffold` 와 구분.
- `skills/web-scrape-provider/SKILL.md` — 웹/비공식 API 수집 공통 패턴: 합법성 사전 점검, 데이터 위치 탐색(SSR `__NEXT_DATA__`/Nuxt devalue/예약 단계), UA 차단 우회, provider+레지스트리 구조, 단계별 비용 트레이드오프.
- `skills/serverless-bot-deploy/SKILL.md` — CLI 도구를 폰/원격에서 쓰는 서버리스 배포: Cloudflare Workers webhook + `waitUntil` 비동기, 시크릿 안전 주입, GitHub Actions 자동배포.

### Changed

- `scripts/new-project.sh` — `--type ts-cli` 추가(`nest|cli|ts-cli`). package.json·src placeholder 치환 포함. **커밋 author 이메일을 개인 gmail 에서 `users.noreply.github.com` 으로 변경(퍼블릭 전환 시 PII 노출 방지)**.
- `playbook/daily-flow.md` — 외부 데이터 합법성 점검 단계 신설, 골격 생성에 `ts-cli` 반영, 유형별 구현 스킬 분기 명시.
- `playbook/checklist.md` — 공통에 외부 데이터 합법성 항목, TypeScript CLI 산출물 섹션 추가.
- `scripts/check-templates.sh` — ts-cli 템플릿 placeholder 검증 추가.
- `.github/workflows/harness-ci.yml` — ts-cli smoke test 잡 추가.

## [0.1.3] - 2026-05-20

### Added

- `templates/cli/` — bash CLI 프로젝트 골격. `bin/<<PROJECT_NAME>>` 단일 entry + `scripts/lib/common.sh` + `tests/entry.bats` + 카탈로그 폴더. (hermes-setup 회고 반영)
- `templates/ci/cli-ci.yml` — docs / shellcheck / bats 3 잡 CI.
- `skills/cli-scaffold/SKILL.md` — bash CLI 컨벤션·골격·테스트·CI·사용자 파일 갱신 패턴 정리.

### Changed

- `scripts/new-project.sh` — `--type nest|cli` 옵션 추가. 기본은 `nest` 라 기존 호출은 그대로 동작. `cli` 일 때 `templates/cli/` 와 `templates/ci/cli-ci.yml` 적용.
- `templates/ci/project-ci.yml` → `templates/ci/nest-ci.yml` 로 이름 변경. CLI 와 구분 명확화.
- `playbook/checklist.md` — Nest / CLI 별 산출물 항목 분리.
- `playbook/daily-flow.md` — 골격 생성 단계에 `--type` 명시.
- `scripts/check-templates.sh` — CLI 템플릿 placeholder 검증 추가.
- `.github/workflows/harness-ci.yml` — CLI smoke test 잡 추가.

## [0.1.2] - 2026-05-20

### Added

- `playbook/add-persistence.md` — MongoDB/Redis/PostgreSQL 추가 절차와 도입 결정 가이드.
- `playbook/add-validation.md` — Zod 도입 절차와 사용 패턴. nest-scaffold 의 Zod 언급을 실제 가산 가이드로 분리.
- `playbook/add-external-api.md` — 외부 API 어댑터 + 키 미설정 시 목업 폴백 패턴. stock-brief 회고에서 검증된 가장 큰 자산.

### Changed

- `skills/problem-framing/SKILL.md` — 운영 모델 결정 4문항(저장소·검증·외부 API·정기 발송) 추가. 필요해질 때 어떤 playbook 을 참조할지 명시.
- `skills/nest-scaffold/SKILL.md` — Zod 가 골격에 기본 포함되어 있다는 오해 제거. 보일러플레이트는 슬림 코어라는 점과 의존성 도입 가이드를 명시.
- `templates/docker/docker-compose.yml` — mongo 등 영속 서비스 추가 예시를 주석으로 안내.

## [0.1.1] - 2026-05-20

### Fixed

- `templates/nest/tsconfig.json` 에 `"types": ["node", "jest"]` 추가. spec 파일에서 jest 전역 타입을 IDE 가 인식하지 못하던 보일러플레이트 결함 해결. (stock-brief 회고 반영)

## [0.1.0] - 2026-05-19

### Added

- 초기 하네스 구조: skills 3개, templates, playbook, scripts.
- `new-project.sh` 프로젝트 생성 스크립트.
- 하네스 자체 CI (`harness-ci.yml`).
