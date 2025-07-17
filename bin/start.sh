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

# Default values
FLAVOR=""
CLEAN=false

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Help message
show_help() {
    echo "Usage: ./start.sh [OPTIONS]"
    echo "Options:"
    echo "-clean, --clean"
    echo "  -f, --flavor     Specify the flavor (development|production)"
    echo "  -h, --help       Show this help message"
}

# Parse flags
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--flavor)
            FLAVOR="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        --clean)
            CLEAN=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            shift
            ;;
    esac
done

# Prompt if no valid flavor
if [[ ! "$FLAVOR" =~ ^(development|production)$ ]]; then
    echo "No valid flavor provided."
    echo "Choose an environment:"
    echo "1. Development"
    echo "2. Production"
    read -p "Enter choice [1-2]: " choice

    case "$choice" in
        1)
            FLAVOR="development"
            ;;
        2)
            FLAVOR="production"
            ;;
        *)
            print_error "Invalid selection. Exiting..."
            exit 1
            ;;
    esac
fi

# Make the setup script executable
chmod +x ./bin/setup-env.sh

# Run setup-env.sh
print_status "Running environment setup for '$FLAVOR'"
bash "$PROJECT_ROOT/bin/setup-env.sh" "$FLAVOR"

ENV_FILE=".env.$FLAVOR"

if [ ! -f "$ENV_FILE" ]; then
    echo "❌ Error: Environment file '$ENV_FILE' not found. Exiting..."
    exit 1
fi

if [[ "$CLEAN" == "true" ]]; then
    # Clean up
    print_status "Cleaning up project..."

    # Remove build directories and generated files
    rm -rf build/
    rm -rf .dart_tool/
    rm -rf .idea/
    rm -f .flutter-plugins
    rm -f .flutter-plugins-dependencies

    # Flutter cleanup and pub get
    print_status "Cleaning up Flutter project..."
    flutter clean

    print_status "Getting Flutter dependencies..."
    flutter pub get
fi


# Prompt user what to do next
print_success "Flutter project setup for '$FLAVOR' complete!"
echo ""
echo "What would you like to do next?"
echo "1. Run the app"
echo "2. Build the APK"
read -p "Enter choice [1-2]: " action

case "$action" in
    1)
        print_status "Running the app..."
        flutter run --flavor "$FLAVOR" -t "lib/main_${FLAVOR}.dart" --verbose --observatory-port=9200
        ;;
    2)
        print_status "Building APK..."
        flutter build apk --flavor "$FLAVOR" -t "lib/main_${FLAVOR}.dart"
        ;;
    *)
        print_error "Invalid choice. Exiting..."
        exit 1
        ;;
esac
