#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
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

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

# Read app name and version from pubspec.yaml
PUBSPEC_FILE="pubspec.yaml"

if [ ! -f "$PUBSPEC_FILE" ]; then
    print_error "pubspec.yaml not found!"
    exit 1
fi

# Extract app name
APP_NAME=$(grep "^name:" "$PUBSPEC_FILE" | sed 's/name: //' | tr -d ' ')

# Extract full version line (e.g. 1.0.0+2)
VERSION_LINE=$(grep "^version:" "$PUBSPEC_FILE" | sed 's/version: //' | tr -d ' ')

# Split into version name and build number
VERSION_NAME=$(echo "$VERSION_LINE" | cut -d'+' -f1)  # 1.0.0
BUILD_NUMBER=$(echo "$VERSION_LINE" | cut -d'+' -f2)  # 2

# Combine as: 1.0.0-build2
VERSION="${VERSION_NAME}-build${BUILD_NUMBER}"

# Get flavor from argument (default: production)
FLAVOR="${1:-production}"

print_status "Renaming APK for flavor: $FLAVOR"
print_status "App name: $APP_NAME"
print_status "Version: $VERSION"

# Define source and destination paths
SOURCE="build/app/outputs/flutter-apk/app-${FLAVOR}-release.apk"
DEST="build/app/outputs/flutter-apk/${APP_NAME}-${FLAVOR}-v${VERSION}.apk"

# Check if source APK exists
if [ ! -f "$SOURCE" ]; then
    print_error "APK not found at: $SOURCE"
    exit 1
fi

# Rename the APK
mv "$SOURCE" "$DEST"

if [ $? -eq 0 ]; then
    print_success "APK renamed successfully!"
    print_success "New name: ${APP_NAME}-${FLAVOR}-v${VERSION}.apk"
    print_success "Location: $DEST"
    
    # Get APK size
    APK_SIZE=$(du -h "$DEST" | cut -f1)
    print_status "APK size: $APK_SIZE"
else
    print_error "Failed to rename APK"
    exit 1
fi
