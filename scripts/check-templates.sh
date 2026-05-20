#!/usr/bin/env bash
# 템플릿이 placeholder 규약을 지키는지 검증한다.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

fail=0

for doc in PROBLEM.md DESIGN.md RETRO.md; do
  path="$ROOT/templates/$doc"
  if [[ ! -f "$path" ]]; then
    err "템플릿 없음: $path"
    fail=1
    continue
  fi
  if ! grep -qE '<<.+>>' "$path"; then
    err "placeholder 없음: $path"
    fail=1
  fi
done

if ! grep -q '<<PROJECT_NAME>>' "$ROOT/templates/nest/package.json"; then
  err "package.json 에 <<PROJECT_NAME>> 없음"
  fail=1
fi

if [[ ! -f "$ROOT/templates/cli/bin/<<PROJECT_NAME>>" ]]; then
  err "templates/cli/bin/<<PROJECT_NAME>> 없음"
  fail=1
fi

if ! grep -q '<<PROJECT_NAME>>' "$ROOT/templates/cli/bin/<<PROJECT_NAME>>"; then
  err "templates/cli/bin/<<PROJECT_NAME>> 내부에 placeholder 없음"
  fail=1
fi

if [[ "$fail" -ne 0 ]]; then
  err "템플릿 placeholder 검증 실패"
  exit 1
fi

log "템플릿 placeholder 검증 통과"
