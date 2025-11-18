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

@test "docker-run-postgresql exists and is executable" {
    [ -x "${TEST_DIR}/docker-run-postgresql" ]
}

@test "docker-run-postgresql help command shows usage" {
    run "${TEST_DIR}/docker-run-postgresql" help
    [ "$status" -eq 0 ]
    [[ "$output" == *"PostgreSQL Database Script"* ]]
    [[ "$output" == *"Usage:"* ]]
}

@test "docker-run-postgresql --help shows usage" {
    run "${TEST_DIR}/docker-run-postgresql" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"PostgreSQL Database Script"* ]]
}

@test "docker-run-postgresql help shows all commands" {
    run "${TEST_DIR}/docker-run-postgresql" help
    [ "$status" -eq 0 ]
    [[ "$output" == *"start"* ]]
    [[ "$output" == *"stop"* ]]
    [[ "$output" == *"restart"* ]]
    [[ "$output" == *"status"* ]]
    [[ "$output" == *"clean"* ]]
    [[ "$output" == *"logs"* ]]
}

@test "docker-run-postgresql help shows options" {
    run "${TEST_DIR}/docker-run-postgresql" help
    [ "$status" -eq 0 ]
    [[ "$output" == *"--container-name"* ]]
    [[ "$output" == *"--port"* ]]
    [[ "$output" == *"--name"* ]]
    [[ "$output" == *"--user"* ]]
    [[ "$output" == *"--password"* ]]
    [[ "$output" == *"--version"* ]]
    [[ "$output" == *"--volume-name"* ]]
    [[ "$output" == *"--debug"* ]]
    [[ "$output" == *"--no-follow"* ]]
}

@test "docker-run-postgresql with invalid command shows error" {
    run "${TEST_DIR}/docker-run-postgresql" invalid-command
    [ "$status" -eq 1 ]
    [[ "$output" == *"Unknown option"* ]]
}

@test "docker-run-postgresql with invalid option shows error" {
    run "${TEST_DIR}/docker-run-postgresql" --invalid-option start
    [ "$status" -eq 1 ]
    [[ "$output" == *"Unknown option"* ]]
}

@test "docker-run-postgresql with no command shows error" {
    run "${TEST_DIR}/docker-run-postgresql"
    [ "$status" -eq 1 ]
    [[ "$output" == *"No command specified"* ]]
}

@test "docker-run-postgresql status works when container doesn't exist" {
    # Mock Docker to avoid actual calls
    docker() {
        if [[ "$1" == "info" ]]; then
            return 0
        fi
        return 1
    }
    export -f docker
    
    run "${TEST_DIR}/docker-run-postgresql" status
    [ "$status" -eq 0 ]
    [[ "$output" == *"does not exist"* ]]
}
