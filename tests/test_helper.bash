# test_helper.sh - Common test utilities

# Determine the test directory
TEST_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"

# Mock Docker commands to avoid actual Docker interactions in tests
mock_docker() {
    # Override docker command for testing
    docker() {
        if [[ "$1" == "info" ]]; then
            return 0
        elif [[ "$1" == "ps" ]]; then
            return 0
        fi
        return 1
    }
    export -f docker
}

# Clean up any test artifacts
cleanup_tests() {
    # Remove any temporary files created during tests
    rm -f /tmp/test-*.log 2>/dev/null || true
}
