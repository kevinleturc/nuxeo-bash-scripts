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

@test "docker-run-mongodb exists and is executable" {
    [ -x "${TEST_DIR}/docker-run-mongodb" ]
}

@test "docker-run-mongodb help command shows usage" {
    run "${TEST_DIR}/docker-run-mongodb" help
    [ "$status" -eq 0 ]
    [[ "$output" == *"MongoDB Database Script"* ]]
    [[ "$output" == *"Usage:"* ]]
}

@test "docker-run-mongodb --help shows usage" {
    run "${TEST_DIR}/docker-run-mongodb" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"MongoDB Database Script"* ]]
}

@test "docker-run-mongodb help shows all commands" {
    run "${TEST_DIR}/docker-run-mongodb" help
    [ "$status" -eq 0 ]
    [[ "$output" == *"start"* ]]
    [[ "$output" == *"stop"* ]]
    [[ "$output" == *"restart"* ]]
    [[ "$output" == *"status"* ]]
    [[ "$output" == *"clean"* ]]
    [[ "$output" == *"logs"* ]]
    [[ "$output" == *"console"* ]]
}

@test "docker-run-mongodb help shows options" {
    run "${TEST_DIR}/docker-run-mongodb" help
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

@test "docker-run-mongodb with invalid command shows error" {
    run "${TEST_DIR}/docker-run-mongodb" invalid-command
    [ "$status" -eq 1 ]
    [[ "$output" == *"Unknown option"* ]]
}

@test "docker-run-mongodb with invalid option shows error" {
    run "${TEST_DIR}/docker-run-mongodb" --invalid-option start
    [ "$status" -eq 1 ]
    [[ "$output" == *"Unknown option"* ]]
}

@test "docker-run-mongodb with no command shows error" {
    run "${TEST_DIR}/docker-run-mongodb"
    [ "$status" -eq 1 ]
    [[ "$output" == *"No command specified"* ]]
}

@test "docker-run-mongodb status works when container doesn't exist" {
    # Mock Docker to avoid actual calls
    docker() {
        if [[ "$1" == "info" ]]; then
            return 0
        fi
        return 1
    }
    export -f docker
    
    run "${TEST_DIR}/docker-run-mongodb" status
    [ "$status" -eq 0 ]
    [[ "$output" == *"does not exist"* ]]
}
