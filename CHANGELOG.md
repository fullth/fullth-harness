# Changelog

하네스의 변경 이력. 스킬·템플릿·플레이북이 바뀔 때마다 한 항목씩 남긴다.

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
