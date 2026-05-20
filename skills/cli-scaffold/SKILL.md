---
name: cli-scaffold
description: bash CLI 도구 골격을 만들 때 사용한다. 단일 entry + scripts 분리 + bats 테스트 + shellcheck CI 컨벤션을 주입한다. 시스템 도구·환경 자동화·.env 갱신 류 도구류 프로젝트에 적합.
---

# CLI Scaffold

bash CLI 도구를 일관된 컨벤션으로 만든다. Nest 프로젝트와 구분된 골격이며,
`new-project.sh <name> --type cli` 가 이 템플릿을 사용한다.

## 골격

```
<project>/
├── bin/<project>           # 단일 entry. case 로 하위 명령 분기.
├── scripts/
│   ├── <cmd>.sh            # 명령별 스크립트
│   └── lib/
│       ├── common.sh       # 로그·색상·require_cmd
│       └── <topic>.sh      # 도메인별 wrapper (예: ollama.sh)
├── data/                   # 카탈로그 (yaml/json). PR 로 갱신.
├── templates/              # 사용자 파일에 주입할 텍스트 블록
├── tests/
│   ├── <cmd>.bats
│   └── fixtures/           # mock 바이너리·픽스처
├── docs/
├── PROBLEM.md / DESIGN.md / RETRO.md
└── .github/workflows/ci.yml   # docs + shellcheck + bats
```

## 컨벤션

- entry 는 `case "$CMD" in ... esac` 로 dispatch. 로직은 `scripts/<cmd>.sh`.
- 모든 스크립트 시작에 `set -euo pipefail`.
- 공통 유틸은 `scripts/lib/common.sh` 로 묶고 `# shellcheck source=lib/common.sh`
  주석으로 lint 만족.
- 외부 명령 wrapper 는 `scripts/lib/<topic>.sh` 에 두고 환경변수로 mock
  주입 가능하게 한다 (예: `HERMES_OLLAMA_BIN`).
- 상태는 사용자 홈 dotdir (`~/.<project>/state.json`). 레포는 카탈로그만.
- 카탈로그 (yaml) 갱신은 PR. 추적성 + 검토.

## 테스트

- bats-core. brew 또는 apt 로 설치.
- 테스트명은 ASCII (bats 가 한글 깨짐).
- mock 픽스처를 `tests/fixtures/` 에 두고 entry 가 호출하는 외부 명령을
  환경변수로 가로채 검증.

## CI

`templates/ci/cli-ci.yml` 가 docs / shellcheck / bats 3 잡을 돈다. `-x -e
SC1091,SC2001` 로 source/스타일 노이즈 제거.

## 사용자 파일 갱신 패턴

도구가 사용자 `.env`·shellrc·config 를 갱신할 때는 마커 블록을 쓴다.

```
# >>> <tool> managed >>>
KEY=value
# <<< <tool> managed <<<
```

블록 사이만 교체하고 사용자 값은 보존. 백업본을 같이 만들면 더 안전하다.

## 비범위 (이 골격에서 안 다룸)

- Node CLI / Go CLI / Rust CLI. 다른 런타임은 별 골격 필요.
- 빌드 산출물 패키징 (brew tap / homebrew formula). 별도 단계.
- 멀티 OS 동시 지원. 우선 macOS 가정. Linux 는 케이스별 분기.
