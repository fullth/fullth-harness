#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  export REPO_ROOT
}

@test "entry: no args prints usage" {
  run "$REPO_ROOT/bin/<<PROJECT_NAME>>"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "<<PROJECT_NAME>>" ]]
}

@test "entry: unknown command fails" {
  run "$REPO_ROOT/bin/<<PROJECT_NAME>>" nope
  [ "$status" -ne 0 ]
}

@test "hello: prints greeting" {
  run "$REPO_ROOT/bin/<<PROJECT_NAME>>" hello bats
  [ "$status" -eq 0 ]
  [[ "$output" =~ "hello, bats" ]]
}
