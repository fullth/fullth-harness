#!/usr/bin/env bash
# 새 프로젝트 골격을 생성한다.
# 사용법: ./scripts/new-project.sh <project-name> [--no-remote]
#   --no-remote : gh repo create 를 건너뛴다 (CI smoke test 용)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

NAME="${1:-}"
NO_REMOTE=false
[[ "${2:-}" == "--no-remote" ]] && NO_REMOTE=true

if [[ -z "$NAME" ]]; then
  err "사용법: $0 <project-name> [--no-remote]"
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

# NestJS 보일러플레이트 복사
cp -r "$ROOT/templates/nest/." "$DEST/"

# 문서 템플릿 복사
cp "$ROOT/templates/PROBLEM.md" "$DEST/PROBLEM.md"
cp "$ROOT/templates/DESIGN.md" "$DEST/DESIGN.md"
cp "$ROOT/templates/RETRO.md" "$DEST/RETRO.md"

# Docker 템플릿 복사
cp "$ROOT/templates/docker/Dockerfile" "$DEST/Dockerfile"
cp "$ROOT/templates/docker/docker-compose.yml" "$DEST/docker-compose.yml"

# CI 템플릿 복사
mkdir -p "$DEST/.github/workflows"
cp "$ROOT/templates/ci/project-ci.yml" "$DEST/.github/workflows/ci.yml"

# package.json 의 name placeholder 치환
PKG="$DEST/package.json"
tmp="$(mktemp)"
sed "s/<<PROJECT_NAME>>/${NAME}/" "$PKG" > "$tmp" && mv "$tmp" "$PKG"

# .gitignore
cat > "$DEST/.gitignore" <<'EOF'
node_modules/
dist/
coverage/
.DS_Store
*.log
.env
EOF

# README
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
