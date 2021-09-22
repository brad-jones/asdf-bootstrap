#!/usr/bin/env bats

# Always use bash compat. syntax
# see: https://bats-core.readthedocs.io/en/stable/writing-tests.html#comment-syntax

function some_example_test_case { #@test
  # shellcheck disable=SC2050
  [ "foo" == "foo" ]
}
