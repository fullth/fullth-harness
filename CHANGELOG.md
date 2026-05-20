# Changelog

하네스의 변경 이력. 스킬·템플릿·플레이북이 바뀔 때마다 한 항목씩 남긴다.

## [0.1.1] - 2026-05-20

### Fixed

- `templates/nest/tsconfig.json` 에 `"types": ["node", "jest"]` 추가. spec 파일에서 jest 전역 타입을 IDE 가 인식하지 못하던 보일러플레이트 결함 해결. (stock-brief 회고 반영)

## [0.1.0] - 2026-05-19

### Added

- 초기 하네스 구조: skills 3개, templates, playbook, scripts.
- `new-project.sh` 프로젝트 생성 스크립트.
- 하네스 자체 CI (`harness-ci.yml`).
