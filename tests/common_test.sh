#!/usr/bin/env bats

# Load the common library
load test_helper

setup() {
    export TEST_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
    source "${TEST_DIR}/lib/common.sh"
}

@test "print_info outputs green INFO message" {
    run print_info "Test message"
    [ "$status" -eq 0 ]
    [[ "$output" == *"[INFO]"* ]]
    [[ "$output" == *"Test message"* ]]
}

@test "print_warn outputs yellow WARN message" {
    run print_warn "Warning message"
    [ "$status" -eq 0 ]
    [[ "$output" == *"[WARN]"* ]]
    [[ "$output" == *"Warning message"* ]]
}

@test "print_error outputs red ERROR message" {
    run print_error "Error message"
    [ "$status" -eq 0 ]
    [[ "$output" == *"[ERROR]"* ]]
    [[ "$output" == *"Error message"* ]]
}

@test "print_debug outputs nothing when DEBUG is false" {
    export DEBUG="false"
    run print_debug "Debug message"
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "print_debug outputs DEBUG message when DEBUG is true" {
    export DEBUG="true"
    run print_debug "Debug message"
    [ "$status" -eq 0 ]
    [[ "$output" == *"[DEBUG]"* ]]
    [[ "$output" == *"Debug message"* ]]
}

@test "container_exists returns 1 when container does not exist" {
    run container_exists "nonexistent-container-12345"
    [ "$status" -eq 1 ]
}

@test "container_running returns 1 when container is not running" {
    run container_running "nonexistent-container-12345"
    [ "$status" -eq 1 ]
}

@test "print_connection_details outputs all provided details" {
    run print_connection_details "Host: localhost" "Port: 5432" "Database: test"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Connection details:"* ]]
    [[ "$output" == *"Host: localhost"* ]]
    [[ "$output" == *"Port: 5432"* ]]
    [[ "$output" == *"Database: test"* ]]
}

@test "check_docker exits with error when docker is not available" {
    # Mock docker command to fail
    docker() {
        return 1
    }
    export -f docker
    
    run check_docker
    [ "$status" -eq 1 ]
    [[ "$output" == *"Docker is not running"* ]]
}

@test "is_supported_command returns 0 for start command" {
    run is_supported_command "start"
    [ "$status" -eq 0 ]
}

@test "is_supported_command returns 0 for stop command" {
    run is_supported_command "stop"
    [ "$status" -eq 0 ]
}

@test "is_supported_command returns 0 for restart command" {
    run is_supported_command "restart"
    [ "$status" -eq 0 ]
}

@test "is_supported_command returns 0 for status command" {
    run is_supported_command "status"
    [ "$status" -eq 0 ]
}

@test "is_supported_command returns 0 for clean command" {
    run is_supported_command "clean"
    [ "$status" -eq 0 ]
}

@test "is_supported_command returns 0 for logs command" {
    run is_supported_command "logs"
    [ "$status" -eq 0 ]
}

@test "is_supported_command returns 0 for console command" {
    run is_supported_command "console"
    [ "$status" -eq 0 ]
}

@test "is_supported_command returns 0 for help command" {
    run is_supported_command "help"
    [ "$status" -eq 0 ]
}

@test "is_supported_command returns 1 for invalid command" {
    run is_supported_command "invalid"
    [ "$status" -eq 1 ]
}

@test "find_command finds start in arguments" {
    run find_command "--port" "5432" "start"
    [ "$status" -eq 0 ]
    [[ "$output" == "start" ]]
}

@test "find_command finds console in arguments" {
    run find_command "--debug" "console" "--port" "5432"
    [ "$status" -eq 0 ]
    [[ "$output" == "console" ]]
}

@test "find_command returns empty for no command" {
    run find_command "--port" "5432" "--name" "test"
    [ "$status" -eq 1 ]
    [ -z "$output" ]
}
