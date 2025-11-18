# Tests

This directory contains unit tests for the nuxeo-bash-scripts project.

## Running Tests

### Prerequisites

Install [bats-core](https://github.com/bats-core/bats-core):

**Ubuntu/Debian:**
```bash
sudo apt-get install bats
```

**macOS:**
```bash
brew install bats-core
```

**From source:**
```bash
git clone https://github.com/bats-core/bats-core.git
cd bats-core
sudo ./install.sh /usr/local
```

### Run All Tests

```bash
cd tests
./run_tests.sh
```

### Run Specific Test File

```bash
bats tests/common_test.sh
bats tests/mongodb_test.sh
bats tests/mysql_test.sh
bats tests/postgresql_test.sh
```

## Test Structure

- **common_test.sh** - Unit tests for lib/common.sh functions
- **mongodb_test.sh** - Unit tests for docker-run-mongodb script
- **mysql_test.sh** - Unit tests for docker-run-mysql script
- **postgresql_test.sh** - Unit tests for docker-run-postgresql script
- **test_helper.bash** - Common test utilities and mocks
- **run_tests.sh** - Test runner script

## Writing Tests

Tests are written using the [bats](https://github.com/bats-core/bats-core) testing framework.

Example test:
```bash
@test "function name does something" {
    run your_function "argument"
    [ "$status" -eq 0 ]
    [[ "$output" == *"expected text"* ]]
}
```

## Continuous Integration

Tests run automatically on:
- Push to main branch
- Pull requests to main branch

The CI workflow runs tests in parallel for better performance using a matrix strategy. Each test file runs in a separate job:
- Common Library tests (common_test.sh)
- MongoDB Script tests (mongodb_test.sh)
- MySQL Script tests (mysql_test.sh)
- PostgreSQL Script tests (postgresql_test.sh)

The workflow uses a single job definition with a matrix to factorize common setup steps (checkout and bats installation), reducing duplication while maintaining parallel execution.

See `.github/workflows/tests.yml` for CI configuration.
