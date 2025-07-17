#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[*]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Arguments
FLAVOR="$1"

print_status $FLAVOR

# Validate input
if [[ ! "$FLAVOR" =~ ^(development|production)$ ]]; then
    print_error "Invalid or missing flavor. Use 'development' or 'production'."
    exit 1
fi

# Paths
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_EXAMPLE_FILE="$PROJECT_ROOT/.env.example"
TARGET_ENV_FILE="$PROJECT_ROOT/.env.$FLAVOR"

# Check .env.example
if [ ! -f "$ENV_EXAMPLE_FILE" ]; then
    print_error ".env.example not found in project root. Cannot proceed."
    exit 1
fi

# Create target env file if missing
if [ ! -f "$TARGET_ENV_FILE" ]; then
    cp "$ENV_EXAMPLE_FILE" "$TARGET_ENV_FILE"
    print_success "$TARGET_ENV_FILE created from .env.example"
else
    print_status "$TARGET_ENV_FILE already exists. Skipping creation."
fi
