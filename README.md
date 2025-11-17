# Nuxeo Bash Scripts

A collection of bash scripts for running databases in the context of Nuxeo development.

## Overview

This repository contains scripts that help developers quickly set up and manage database instances for Nuxeo development. These scripts are designed to work with Docker and provide easy-to-use commands for starting, stopping, and managing various database systems.

**Note:** These scripts are tied to personal development workflows and computer configurations, but are shared to help other Nuxeo developers.

## Prerequisites

- Docker installed and running
- Bash shell (Linux/macOS) or WSL (Windows)
- Sufficient permissions to run Docker commands

## Installation

### Quick Setup

Clone the repository to `~/.scripts/nuxeo-bash-scripts` and add it to your PATH:

```bash
# Create the .scripts directory if it doesn't exist
mkdir -p ~/.scripts

# Clone the repository
git clone https://github.com/kevinleturc/nuxeo-bash-scripts.git ~/.scripts/nuxeo-bash-scripts

# Add to your PATH (for zsh)
echo 'export PATH="$PATH:${HOME}/.scripts:${HOME}/.scripts/nuxeo-bash-scripts"' >> ~/.zshrc
source ~/.zshrc

# For bash users
echo 'export PATH="$PATH:${HOME}/.scripts:${HOME}/.scripts/nuxeo-bash-scripts"' >> ~/.bashrc
source ~/.bashrc
```

After setup, you can use the commands directly:
```bash
docker-run-mongodb start
docker-run-postgresql start
docker-run-mysql start
```

### Alternative Installation

You can also clone the repository anywhere and create symlinks or add that directory to your PATH.

## Available Database Scripts

### PostgreSQL
- **Command:** `docker-run-postgresql`
- **Description:** Starts a PostgreSQL container configured for Nuxeo development
- **Default Port:** 5432
- **Default Database:** nuxeo
- **Default User:** nuxeo
- **Default Password:** nuxeo

### MySQL
- **Command:** `docker-run-mysql`
- **Description:** Starts a MySQL container configured for Nuxeo development
- **Default Port:** 3306
- **Default Database:** nuxeo
- **Default User:** nuxeo
- **Default Password:** nuxeo

### MongoDB
- **Command:** `docker-run-mongodb`
- **Description:** Starts a MongoDB container configured for Nuxeo development
- **Default Port:** 27017
- **Default Database:** nuxeo
- **Default User:** nuxeo
- **Default Password:** nuxeo

## Usage

### Starting a Database

Each script provides commands to start, stop, and manage the database:

```bash
# Start a PostgreSQL instance
docker-run-postgresql start

# Stop the PostgreSQL instance
docker-run-postgresql stop

# Restart the PostgreSQL instance
docker-run-postgresql restart

# View status of the PostgreSQL instance
docker-run-postgresql status

# Remove the PostgreSQL container and data
docker-run-postgresql clean

# View logs
docker-run-postgresql logs
```

The same commands work for other databases (replace `docker-run-postgresql` with `docker-run-mysql` or `docker-run-mongodb`).

### Customization

You can customize database settings using command-line options:

```bash
# Custom PostgreSQL port
docker-run-postgresql --port 5433 start

# Custom database name and user
docker-run-postgresql --name mydb --user myuser --password mypass start

# Enable debug logging
docker-run-mongodb --debug start

# View logs without following
docker-run-mysql --no-follow logs
```

### Available Options

All scripts support the following options:
- `--container-name NAME` - Custom container name
- `--port PORT` - Custom host port
- `--name NAME` - Database name
- `--user USER` - Database user
- `--password PASS` - Database password
- `--version VERSION` - Database version
- `--volume-name NAME` - Docker volume name
- `--debug` - Enable debug logging
- `--no-follow` - Don't follow logs (for logs command)

## Script Structure

Each database script follows a common pattern:
- Container naming: `nuxeo-{database}-dev`
- Data persistence: Docker volumes for data persistence
- Configuration: Command-line options for customization
- Commands: start, stop, restart, status, clean, logs

### Code Organization

The repository uses a modular structure:
- **Database scripts** (`docker-run-postgresql`, `docker-run-mysql`, `docker-run-mongodb`): Database-specific configuration and startup logic
- **Common library** (`lib/common.sh`): Shared functions for Docker container management, including:
  - Color-coded output functions
  - Docker availability checks
  - Container lifecycle management (stop, status, clean, logs)
  - Health check utilities

This modular approach reduces code duplication and makes maintenance easier.

## Testing

Unit tests are provided for the common library and database scripts.

### Running Tests

```bash
cd tests
./run_tests.sh
```

See [tests/README.md](tests/README.md) for more information about running and writing tests.

### Continuous Integration

Tests run automatically via GitHub Actions on:
- Push to main branch
- Pull requests

## Contributing

Feel free to fork this repository and adapt the scripts to your needs. Pull requests for improvements are welcome!

When contributing:
1. Ensure all tests pass: `cd tests && ./run_tests.sh`
2. Add tests for new functionality
3. Follow the existing code style

## License

Apache License 2.0 - see LICENSE file for details