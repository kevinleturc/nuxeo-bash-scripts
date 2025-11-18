#!/usr/bin/env bats

# Load test helper
load test_helper

setup() {
    export TEST_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
    # Source the common library first
    source "${TEST_DIR}/lib/common.sh"
    # Override container functions to avoid actual Docker calls
    container_exists() { return 1; }
    container_running() { return 1; }
    export -f container_exists
    export -f container_running
}

@test "docker-run-mysql exists and is executable" {
    [ -x "${TEST_DIR}/docker-run-mysql" ]
}

@test "docker-run-mysql help command shows usage" {
    run "${TEST_DIR}/docker-run-mysql" help
    [ "$status" -eq 0 ]
    [[ "$output" == *"MySQL Database Script"* ]]
    [[ "$output" == *"Usage:"* ]]
}

@test "docker-run-mysql --help shows usage" {
    run "${TEST_DIR}/docker-run-mysql" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"MySQL Database Script"* ]]
}

@test "docker-run-mysql help shows all commands" {
    run "${TEST_DIR}/docker-run-mysql" help
    [ "$status" -eq 0 ]
    [[ "$output" == *"start"* ]]
    [[ "$output" == *"stop"* ]]
    [[ "$output" == *"restart"* ]]
    [[ "$output" == *"status"* ]]
    [[ "$output" == *"clean"* ]]
    [[ "$output" == *"logs"* ]]
    [[ "$output" == *"console"* ]]
}

@test "docker-run-mysql help shows options" {
    run "${TEST_DIR}/docker-run-mysql" help
    [ "$status" -eq 0 ]
    [[ "$output" == *"--container-name"* ]]
    [[ "$output" == *"--port"* ]]
    [[ "$output" == *"--name"* ]]
    [[ "$output" == *"--user"* ]]
    [[ "$output" == *"--password"* ]]
    [[ "$output" == *"--root-password"* ]]
    [[ "$output" == *"--version"* ]]
    [[ "$output" == *"--volume-name"* ]]
    [[ "$output" == *"--debug"* ]]
    [[ "$output" == *"--no-follow"* ]]
}

@test "docker-run-mysql with invalid command shows error" {
    run "${TEST_DIR}/docker-run-mysql" invalid-command
    [ "$status" -eq 1 ]
    [[ "$output" == *"Unknown option"* ]]
}

@test "docker-run-mysql with invalid option shows error" {
    run "${TEST_DIR}/docker-run-mysql" --invalid-option start
    [ "$status" -eq 1 ]
    [[ "$output" == *"Unknown option"* ]]
}

@test "docker-run-mysql with no command shows error" {
    run "${TEST_DIR}/docker-run-mysql"
    [ "$status" -eq 1 ]
    [[ "$output" == *"No command specified"* ]]
}

@test "docker-run-mysql status works when container doesn't exist" {
    # Mock Docker to avoid actual calls
    docker() {
        if [[ "$1" == "info" ]]; then
            return 0
        fi
        return 1
    }
    export -f docker
    
    run "${TEST_DIR}/docker-run-mysql" status
    [ "$status" -eq 0 ]
    [[ "$output" == *"does not exist"* ]]
}
