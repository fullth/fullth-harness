#!/usr/bin/env bash
# 새 프로젝트 골격을 생성한다.
# 사용법: ./scripts/new-project.sh <project-name> [--type nest|cli] [--no-remote]
#   --type     : 프로젝트 유형. 기본 nest. cli 는 bash CLI 골격.
#   --no-remote: gh repo create 를 건너뛴다 (CI smoke test 용)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

NAME=""
TYPE="nest"
NO_REMOTE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --type) TYPE="${2:-}"; shift 2 ;;
    --no-remote) NO_REMOTE=true; shift ;;
    -*) err "알 수 없는 옵션: $1"; exit 1 ;;
    *) [[ -z "$NAME" ]] && NAME="$1" || { err "잉여 인자: $1"; exit 1; }; shift ;;
  esac
done

if [[ -z "$NAME" ]]; then
  err "사용법: $0 <project-name> [--type nest|cli] [--no-remote]"
  exit 1
fi

if [[ "$TYPE" != "nest" && "$TYPE" != "cli" ]]; then
  err "--type 은 nest 또는 cli 만 가능. 받음: $TYPE"
  exit 1
fi

validate_project_name "$NAME"

DATE="$(date +%Y-%m-%d)"
DEST="${HARNESS_PROJECT_DIR:-$HOME/WebstormProjects}/${DATE}-${NAME}"

if [[ -e "$DEST" ]]; then
  err "이미 존재한다: $DEST"
  exit 1
fi

log "프로젝트 골격 생성: $DEST"
mkdir -p "$DEST"

mkdir -p "$DEST/.github/workflows"

# 문서 템플릿 복사 (모든 유형 공통)
cp "$ROOT/templates/PROBLEM.md" "$DEST/PROBLEM.md"
cp "$ROOT/templates/DESIGN.md" "$DEST/DESIGN.md"
cp "$ROOT/templates/RETRO.md" "$DEST/RETRO.md"

if [[ "$TYPE" == "nest" ]]; then
  cp -r "$ROOT/templates/nest/." "$DEST/"
  cp "$ROOT/templates/docker/Dockerfile" "$DEST/Dockerfile"
  cp "$ROOT/templates/docker/docker-compose.yml" "$DEST/docker-compose.yml"
  cp "$ROOT/templates/ci/nest-ci.yml" "$DEST/.github/workflows/ci.yml"

  PKG="$DEST/package.json"
  tmp="$(mktemp)"
  sed "s/<<PROJECT_NAME>>/${NAME}/" "$PKG" > "$tmp" && mv "$tmp" "$PKG"
fi

if [[ "$TYPE" == "cli" ]]; then
  cp -r "$ROOT/templates/cli/." "$DEST/"
  cp "$ROOT/templates/ci/cli-ci.yml" "$DEST/.github/workflows/ci.yml"

  # bin/<<PROJECT_NAME>> 파일명과 내부 placeholder 치환
  mv "$DEST/bin/<<PROJECT_NAME>>" "$DEST/bin/${NAME}"
  chmod +x "$DEST/bin/${NAME}"
  chmod +x "$DEST"/scripts/*.sh 2>/dev/null || true

  # 파일 내부 placeholder 치환 (sed -i 호환 처리)
  find "$DEST" -type f \( -name '*.sh' -o -name '*.bats' -o -name "${NAME}" \) -print0 \
    | while IFS= read -r -d '' file; do
        tmp="$(mktemp)"
        sed "s/<<PROJECT_NAME>>/${NAME}/g" "$file" > "$tmp"
        # 실행 권한 유지
        if [[ -x "$file" ]]; then
          mv "$tmp" "$file"
          chmod +x "$file"
        else
          mv "$tmp" "$file"
        fi
      done
fi

# .gitignore (유형별)
if [[ "$TYPE" == "nest" ]]; then
  cat > "$DEST/.gitignore" <<'EOF'
node_modules/
dist/
coverage/
.DS_Store
*.log
.env
EOF
else
  cat > "$DEST/.gitignore" <<'EOF'
.DS_Store
*.log
EOF
fi

# README (유형별)
if [[ "$TYPE" == "nest" ]]; then
  cat > "$DEST/README.md" <<EOF
# ${NAME}

## 시작

\`\`\`bash
npm install
npm run start:dev
\`\`\`

## 문서

- [PROBLEM.md](./PROBLEM.md) — 문제정의
- [DESIGN.md](./DESIGN.md) — 설계
- [RETRO.md](./RETRO.md) — 회고
EOF
else
  cat > "$DEST/README.md" <<EOF
# ${NAME}

## 시작

\`\`\`bash
./bin/${NAME} help
\`\`\`

## 테스트

\`\`\`bash
brew install bats-core
bats tests/
\`\`\`

## 문서

- [PROBLEM.md](./PROBLEM.md) — 문제정의
- [DESIGN.md](./DESIGN.md) — 설계
- [RETRO.md](./RETRO.md) — 회고
EOF
fi

# git init
cd "$DEST"
git init -q
git add -A
git -c user.name="fullth" -c user.email="xoghksdla@gmail.com" \
  commit -q -m "프로젝트 골격 생성"

log "git 초기화 완료"

if [[ "$NO_REMOTE" == true ]]; then
  warn "--no-remote: gh repo create 건너뜀"
else
  if command -v gh >/dev/null 2>&1; then
    log "GitHub 저장소 생성: fullth/${NAME}"
    gh repo create "fullth/${NAME}" --private --source=. --remote=origin
  else
    warn "gh CLI 없음. 원격 저장소는 수동으로 연결한다."
  fi
fi

log "완료: $DEST"
