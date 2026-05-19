#!/usr/bin/env bash
# 스크립트 공통 함수. source 해서 쓴다.

set -euo pipefail

log()  { printf '\033[1;34m[harness]\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m[harness]\033[0m %s\n' "$1"; }
err()  { printf '\033[1;31m[harness]\033[0m %s\n' "$1" >&2; }

# 하네스 저장소 루트 절대경로를 출력한다.
harness_root() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"
  cd "$script_dir/.." && pwd
}

# 인자로 받은 이름이 kebab-case 인지 검증한다.
validate_project_name() {
  local name="$1"
  if [[ ! "$name" =~ ^[a-z][a-z0-9-]*[a-z0-9]$ ]]; then
    err "프로젝트 이름은 kebab-case 여야 한다: $name"
    return 1
  fi
}
