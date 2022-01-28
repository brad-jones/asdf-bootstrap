#!/usr/bin/env bats

# see: https://bats-core.readthedocs.io

function setup {
  load 'test_helpers/bats-support/load'
  load 'test_helpers/bats-assert/load'
}

function arrange {
  local tmpDir="${1:-"./tests/mocks/${FUNCNAME[1]}"}"
  local scriptName="${2:-"task"}"
  mkdir -p "${tmpDir}"
  if [ ! -f "${tmpDir}/${scriptName}" ]; then
    cp ./task "${tmpDir}/${scriptName}"
    sed -i -e 's/main "$@"//g' -e 's/exit $?//g' "${tmpDir}/${scriptName}"
  fi
  # shellcheck disable=SC1090 disable=SC1091
  source "${tmpDir}/${scriptName}"
}

function get_script_name_should_return_the_name_of_the_script { #@test
  # Arrange
  local actual expected mockDir
  mockDir="$PWD/tests/mocks/${FUNCNAME[0]}"
  expected="my-custom-tool"
  arrange "${mockDir}" "${expected}"

  # Act
  actual="$(get_script_name)"

  # Assert
  assert_equal "${actual}" "${expected}"
}

function get_script_dir_should_return_dir_that_the_script_is_located_in { #@test
  # Arrange
  local actual expected mockDir
  mockDir="$PWD/tests/mocks/${FUNCNAME[0]}"
  expected="${mockDir}"
  arrange "${mockDir}"

  # Act
  actual="$(get_script_dir)"

  # Assert
  assert_equal "${actual}" "${expected}"
}

function load_dot_env_should_load_variables_from_dot_env_file { #@test
  # Arrange
  local actual expected mockDir
  mockDir="$PWD/tests/mocks/${FUNCNAME[0]}"
  arrange "${mockDir}"
  expected="abc"
  echo "FOO_BAR=${expected}" >"${mockDir}/.env"

  # Act
  load_dot_env "${mockDir}/.env"
  actual="${FOO_BAR}"

  # Assert
  assert_equal "${actual}" "${expected}"
}

function load_dot_env_should_not_fail_when_given_a_non_existent_path { #@test
  # Arrange
  local mockDir="$PWD/tests/mocks/${FUNCNAME[0]}"
  arrange "${mockDir}"

  # Act
  run load_dot_env "${mockDir}/.env"

  # Assert
  assert_success
}

function log_std_err_should_send_output_to_stderr { #@test
  # Arrange
  local mockDir="$PWD/tests/mocks/${FUNCNAME[0]}"
  arrange "${mockDir}"

  # Act
  log_std_err "hello" 1>"${mockDir}/stdout" 2>"${mockDir}/stderr"

  # Assert
  assert_equal "$(cat "${mockDir}"/stdout)" ""
  assert_equal "$(cat "${mockDir}"/stderr)" "hello"
}

function log_heading_should_output_a_heading_to_stdout { #@test
  # Arrange
  local expected mockDir
  mockDir="$PWD/tests/mocks/${FUNCNAME[0]}"
  arrange "${mockDir}"
  expected="! >>> hello\n! -------------------------------------------------------------------------------------------------------------------- !"

  # Act
  log_heading "hello" 1>"${mockDir}/stdout" 2>"${mockDir}/stderr"

  # Assert
  assert_equal "$(cat "${mockDir}"/stdout)" "$(echo -e "${expected}")"
  assert_equal "$(cat "${mockDir}"/stderr)" ""
}

function log_missing_command_should_output_an_error_to_stderr { #@test
  # Arrange
  local expected mockDir
  mockDir="$PWD/tests/mocks/${FUNCNAME[0]}"
  arrange "${mockDir}"
  expected="Error: foo not found!\n\nThis bootstrap script can not operate without it.\nPlease install manually.\n\nsee: http://bar"

  # Act
  log_missing_command "foo" "http://bar" 1>"${mockDir}/stdout" 2>"${mockDir}/stderr"

  # Assert
  assert_equal "$(cat "${mockDir}"/stdout)" ""
  assert_equal "$(cat "${mockDir}"/stderr)" "$(echo -e "${expected}")"
}

function command_exist_should_return_true_if_a_cmd_exists { #@test
  # Arrange
  arrange

  # Act
  run command_exist "bash"

  # Assert
  assert_success
}

function command_exist_should_return_false_if_a_cmd_does_not_exist { #@test
  # Arrange
  arrange

  # Act
  run command_exist "75cab649-a7c7-4fe7-bf5c-9a36ad76e44b"

  # Assert
  assert_failure
}

function install_asdf_should_git_clone_asdf { #@test
  # Arrange
  local mockDir="$PWD/tests/mocks/${FUNCNAME[0]}"
  arrange "${mockDir}"

  # Act
  run install_asdf "https://github.com/asdf-vm/asdf.git" "v0.8.1" "${mockDir}/asdf"

  # Assert
  assert_success
  assert_equal "$(cat "${mockDir}/asdf/VERSION")" "v0.8.1"
}

function install_asdf_plugin_should_git_clone_a_plugin { #@test
  # Arrange
  local mockDir="$PWD/tests/mocks/${FUNCNAME[0]}"
  arrange "${mockDir}"

  # Act
  run install_asdf_plugin \
    "jq" "https://github.com/azmcode/asdf-jq.git" \
    "844d7123a80bccdfd8d9cf5bd64d0d36d71db382" \
    "${mockDir}"

  # Assert
  assert_success
  assert_equal "$(head -n 1 <"${mockDir}/plugins/jq/README.md")" "# asdf-jq"
}

function get_checksum_of_dir_should_return_checksum { #@test
  # Arrange
  local actual expected mockDir
  mockDir="$PWD/tests/mocks/${FUNCNAME[0]}"
  arrange "${mockDir}"
  mkdir -p "${mockDir}/data"
  echo "bar" >"${mockDir}/data/foo.txt"
  echo "alert('hello')" >"${mockDir}/data/index.js"
  echo "<?php echo 'world';" >"${mockDir}/data/index.php"
  expected="sha512:8cf809fcd18f6b44757fe218bfcc554f722a868727e6fbc6f68961206f1fef1d83ccbc299cd8815c9f23b58eb013b306d5313f34d41227595cbba340061d165f"

  # Act
  actual="$(get_checksum_of_dir "${mockDir}/data")"

  # Assert
  assert_equal "${actual}" "${expected}"
}

function export_tool_versions_should_export_version_numbers { #@test
  # Arrange
  local mockDir="$PWD/tests/mocks/${FUNCNAME[0]}"
  arrange "${mockDir}"
  echo "bar 1.2.3" >>"${mockDir}/.tool-versions"
  echo "baz 4.5.6" >>"${mockDir}/.tool-versions"

  # Act
  export_tool_versions "${mockDir}/.tool-versions"

  # Assert
  # shellcheck disable=2154
  assert_equal "${ASDF_bar_VERSION}" "1.2.3"
  # shellcheck disable=2154
  assert_equal "${ASDF_baz_VERSION}" "4.5.6"
}

function ensure_lock_matches_should_fail_when_checksums_do_not_match { #@test
  # Arrange
  local mockDir="$PWD/tests/mocks/${FUNCNAME[0]}"
  arrange "${mockDir}"
  mkdir -p "${mockDir}/installs/bar/1.2.3"
  echo "# hello world" >"${mockDir}/installs/bar/1.2.3/README.md"
  echo "execute me, yay" >"${mockDir}/installs/bar/1.2.3/bar.exe"
  echo "bar 1.2.3 sha512:in-valid" >>"${mockDir}/.tool-versions.lock"
  export ASDF_DATA_DIR="${mockDir}"
  export ASDF_TOOL_VERSIONS_LOCKFILE="${mockDir}/.tool-versions.lock"

  # Act
  run ensure_lock_matches "bar" "1.2.3"

  # Assert
  assert_failure
}
