#!/usr/bin/env bash
# 모든 skills/*/SKILL.md 의 frontmatter 유효성을 검증한다.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

fail=0

shopt -s nullglob
for skill in "$ROOT"/skills/*/SKILL.md; do
  # 첫 줄이 --- 인지 확인
  if [[ "$(head -n1 "$skill")" != "---" ]]; then
    err "frontmatter 없음: $skill"
    fail=1
    continue
  fi
  # 두 번째 --- 까지를 frontmatter 로 추출
  fm="$(awk 'NR>1 && /^---$/{exit} NR>1{print}' "$skill")"
  if ! grep -q '^name:' <<<"$fm"; then
    err "name 키 없음: $skill"
    fail=1
  fi
  if ! grep -q '^description:' <<<"$fm"; then
    err "description 키 없음: $skill"
    fail=1
  fi
done

if [[ "$fail" -ne 0 ]]; then
  err "SKILL frontmatter 검증 실패"
  exit 1
fi

log "SKILL frontmatter 검증 통과"
