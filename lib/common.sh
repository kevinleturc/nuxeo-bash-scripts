#!/bin/bash

# Common Library for Nuxeo Database Scripts
# This library provides shared functions for Docker container management

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_debug() {
    if [[ "${DEBUG:-false}" == "true" ]]; then
        echo -e "\033[0;36m[DEBUG]${NC} $1"
    fi
}

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
}

# Function to check if container exists
# Args: $1 - Container name
container_exists() {
    local container_name="$1"
    docker ps -a --format '{{.Names}}' | grep -q "^${container_name}$"
}

# Function to check if container is running
# Args: $1 - Container name
container_running() {
    local container_name="$1"
    docker ps --format '{{.Names}}' | grep -q "^${container_name}$"
}

# Function to stop a container
# Args: $1 - Container name
#       $2 - Database name (for display)
stop_container() {
    local container_name="$1"
    local db_name="$2"
    check_docker
    
    if ! container_running "$container_name"; then
        print_warn "${db_name} container '${container_name}' is not running."
        return 0
    fi
    
    print_info "Stopping ${db_name} container '${container_name}'..."
    docker stop "${container_name}"
    print_info "${db_name} stopped."
}

# Function to show container status
# Args: $1 - Container name
#       $2 - Database name (for display)
show_container_status() {
    local container_name="$1"
    local db_name="$2"
    check_docker
    
    if container_running "$container_name"; then
        print_info "${db_name} container '${container_name}' is running."
        docker ps --filter "name=${container_name}" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    elif container_exists "$container_name"; then
        print_warn "${db_name} container '${container_name}' exists but is not running."
    else
        print_warn "${db_name} container '${container_name}' does not exist."
    fi
}

# Function to clean up (remove container and volume)
# Args: $1 - Container name
#       $2 - Volume name
#       $3 - Database name (for display)
clean_container() {
    local container_name="$1"
    local volume_name="$2"
    local db_name="$3"
    check_docker
    
    if container_running "$container_name"; then
        print_info "Stopping ${db_name} container '${container_name}'..."
        docker stop "${container_name}"
    fi
    
    if container_exists "$container_name"; then
        print_info "Removing ${db_name} container '${container_name}'..."
        docker rm "${container_name}"
    fi
    
    if docker volume ls --format '{{.Name}}' | grep -q "^${volume_name}$"; then
        print_warn "Removing ${db_name} data volume '${volume_name}'..."
        docker volume rm "${volume_name}"
        print_info "${db_name} container and data removed."
    else
        print_info "${db_name} container removed."
    fi
}

# Function to show container logs
# Args: $1 - Container name
#       $2 - Database name (for display)
#       $3 - Follow flag (optional, default: true)
show_container_logs() {
    local container_name="$1"
    local db_name="$2"
    local follow="${3:-true}"
    check_docker
    
    if ! container_exists "$container_name"; then
        print_error "${db_name} container '${container_name}' does not exist."
        exit 1
    fi
    
    if [[ "$follow" == "true" ]]; then
        docker logs -f "${container_name}"
    else
        docker logs "${container_name}"
    fi
}

# Function to wait for container to be ready
# Args: $1 - Database name (for display)
#       $2 - Health check command to run inside container
#       $3 - Max attempts (default: 30)
wait_for_container() {
    local db_name="$1"
    local health_check="$2"
    local max_attempts="${3:-30}"
    
    print_info "Waiting for ${db_name} to be ready..."
    sleep 3
    
    for i in $(seq 1 "$max_attempts"); do
        print_debug "Health check attempt $i/$max_attempts, sleeping 1 second..."
        if eval "$health_check" > /dev/null 2>&1; then
            print_info "${db_name} is ready!"
            return 0
        fi
        sleep 1
    done
    
    print_error "${db_name} failed to start properly. Check logs with: docker logs <container_name>"
    exit 1
}

# Function to print connection details
# Args: All connection details as key-value pairs
print_connection_details() {
    print_info "Connection details:"
    while [[ $# -gt 0 ]]; do
        print_info "  $1"
        shift
    done
}
