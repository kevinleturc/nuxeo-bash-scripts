#!/bin/bash

# Test runner script for nuxeo-bash-scripts
# This script runs all tests using bats

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "========================================="
echo "Running tests for nuxeo-bash-scripts"
echo "========================================="
echo ""

# Check if bats is installed
if ! command -v bats &> /dev/null; then
    echo "ERROR: bats is not installed."
    echo ""
    echo "Please install bats-core:"
    echo "  On Ubuntu/Debian: sudo apt-get install bats"
    echo "  On macOS: brew install bats-core"
    echo "  Or see: https://github.com/bats-core/bats-core#installation"
    echo ""
    exit 1
fi

echo "Using bats version:"
bats --version
echo ""

# Run all test files
TEST_FILES="${SCRIPT_DIR}"/*.sh

echo "Running tests..."
echo ""

if bats --tap ${TEST_FILES}; then
    echo ""
    echo "========================================="
    echo "All tests passed! ✓"
    echo "========================================="
    exit 0
else
    echo ""
    echo "========================================="
    echo "Some tests failed! ✗"
    echo "========================================="
    exit 1
fi
