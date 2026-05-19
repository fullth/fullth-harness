# fullth-harness

NestJS 프로젝트를 일관된 골격으로 빠르게 시작하고, 각 프로젝트의 회고를
도구 자체에 되먹여 점진적으로 개선하는 개발 하네스다.

## 구성

- `skills/` — Claude Code 스킬. 프로젝트 진행을 돕고 계속 보강된다.
- `templates/` — 프로젝트 문서·CI·Docker·NestJS 보일러플레이트.
- `playbook/` — 프로젝트 진행 순서와 산출물 체크리스트.
- `scripts/` — 프로젝트 생성·검증 스크립트.
- `backlog.md` — 프로젝트 아이디어 목록.
- `CHANGELOG.md` — 하네스 버전 이력.

## 새 프로젝트 시작

```bash
./scripts/new-project.sh <project-name>
```

날짜 prefix 폴더에 NestJS 골격을 만들고, 문서 템플릿과 CI를 주입한 뒤
별도 GitHub 저장소로 연결한다. 이후 `playbook/daily-flow.md`를 따른다.

## 진화 원칙

각 프로젝트는 `RETRO.md`에 "하네스 개선점"을 남긴다. `retro-harvest`
스킬이 이를 하네스의 스킬·플레이북에 반영한다. `CHANGELOG.md`가 그
이력을 기록한다.
