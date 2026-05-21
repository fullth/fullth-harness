# shellcheck shell=bash
# 공통 로그/유틸. source 전용.

if [[ -t 1 ]]; then
  C_RESET=$'\033[0m'
  C_DIM=$'\033[2m'
  C_BLUE=$'\033[1;34m'
  C_YELLOW=$'\033[1;33m'
  C_RED=$'\033[1;31m'
  C_GREEN=$'\033[1;32m'
else
  C_RESET=''; C_DIM=''; C_BLUE=''; C_YELLOW=''; C_RED=''; C_GREEN=''
fi

log()  { printf "%s[<<PROJECT_NAME>>]%s %s\n" "$C_BLUE"   "$C_RESET" "$*"; }
warn() { printf "%s[<<PROJECT_NAME>>]%s %s\n" "$C_YELLOW" "$C_RESET" "$*" >&2; }
err()  { printf "%s[<<PROJECT_NAME>>]%s %s\n" "$C_RED"    "$C_RESET" "$*" >&2; }
ok()   { printf "%s[<<PROJECT_NAME>>]%s %s\n" "$C_GREEN"  "$C_RESET" "$*"; }
dim()  { printf "%s%s%s\n"                    "$C_DIM"    "$*" "$C_RESET"; }

require_cmd() {
  local cmd=$1 hint=${2:-}
  if ! command -v "$cmd" >/dev/null 2>&1; then
    err "필수 명령 없음: $cmd"
    [[ -n "$hint" ]] && err "  $hint"
    exit 1
  fi
}

require_macos() {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    err "macOS 전용 도구. 현재: $(uname -s)"
    exit 1
  fi
}

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
export REPO_ROOT
