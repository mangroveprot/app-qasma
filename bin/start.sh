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

# Function to increment version
increment_version() {
    local increment_type=$1
    local pubspec_file="pubspec.yaml"
    
    if [ ! -f "$pubspec_file" ]; then
        print_error "pubspec.yaml not found!"
        return 1
    fi
    
    # Extract current version
    local current_version=$(grep "^version:" "$pubspec_file" | sed 's/version: //')
    local version_number=$(echo "$current_version" | cut -d'+' -f1)
    local build_number=$(echo "$current_version" | cut -d'+' -f2)
    
    local major=$(echo "$version_number" | cut -d'.' -f1)
    local minor=$(echo "$version_number" | cut -d'.' -f2)
    local patch=$(echo "$version_number" | cut -d'.' -f3)
    
    print_status "Current version: $current_version"
    
    case "$increment_type" in
        build)
            build_number=$((build_number + 1))
            ;;
        patch)
            patch=$((patch + 1))
            build_number=$((build_number + 1))
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            build_number=$((build_number + 1))
            ;;
        major)
            major=$((major + 1))
            minor=0
            patch=0
            build_number=$((build_number + 1))
            ;;
        none)
            print_warning "Skipping version increment"
            return 0
            ;;
        *)
            print_error "Invalid increment type: $increment_type"
            return 1
            ;;
    esac
    
    local new_version="${major}.${minor}.${patch}+${build_number}"
    
    # Update pubspec.yaml
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/^version:.*/version: $new_version/" "$pubspec_file"
    else
        # Linux
        sed -i "s/^version:.*/version: $new_version/" "$pubspec_file"
    fi
    
    print_success "Version updated: $current_version → $new_version"
}

# Default values
FLAVOR=""
CLEAN=false
INCREMENT_TYPE="build"
SKIP_INCREMENT=false

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Help message
show_help() {
    echo "Usage: ./start.sh [OPTIONS]"
    echo "Options:"
    echo "  -f, --flavor       Specify the flavor (development|production)"
    echo "  -i, --increment    Version increment type (build|patch|minor|major|none)"
    echo "                     Default: build (increments build number only)"
    echo "  --clean            Clean project before build"
    echo "  --skip-increment   Skip version increment"
    echo "  -h, --help         Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./start.sh -f production -i patch    # Increment patch version"
    echo "  ./start.sh -f development --clean    # Clean build"
    echo "  ./start.sh --skip-increment           # Don't increment version"
}

# Parse flags
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--flavor)
            FLAVOR="$2"
            shift 2
            ;;
        -i|--increment)
            INCREMENT_TYPE="$2"
            shift 2
            ;;
        --skip-increment)
            SKIP_INCREMENT=true
            shift
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
            show_help
            exit 1
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
chmod +x ./bin/rename-apk.sh

# Run setup-env.sh
print_status "Running environment setup for '$FLAVOR'"
bash "$PROJECT_ROOT/bin/setup-env.sh" "$FLAVOR"

ENV_FILE=".env.$FLAVOR"

if [ ! -f "$ENV_FILE" ]; then
    print_error "Environment file '$ENV_FILE' not found. Exiting..."
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
        # Increment version only for production builds
        if [[ "$SKIP_INCREMENT" == "false" ]] && [[ "$FLAVOR" == "production" ]]; then
            echo ""
            echo "Select version increment type:"
            echo "1. Build   - Just increment build number (1.0.0+1 → 1.0.0+2)"
            echo "2. Patch   - Bug fixes (1.0.0+1 → 1.0.1+2)"
            echo "3. Minor   - New features (1.0.0+1 → 1.1.0+2)"
            echo "4. Major   - Breaking changes (1.0.0+1 → 2.0.0+2)"
            echo "5. None    - Skip increment"
            read -p "Enter choice [1-5]: " version_choice
            
            case "$version_choice" in
                1)
                    INCREMENT_TYPE="build"
                    ;;
                2)
                    INCREMENT_TYPE="patch"
                    ;;
                3)
                    INCREMENT_TYPE="minor"
                    ;;
                4)
                    INCREMENT_TYPE="major"
                    ;;
                5)
                    INCREMENT_TYPE="none"
                    ;;
                *)
                    print_warning "Invalid choice. Using default: build"
                    INCREMENT_TYPE="build"
                    ;;
            esac
            
            if [[ "$INCREMENT_TYPE" != "none" ]]; then
                print_status "Incrementing version ($INCREMENT_TYPE)..."
                increment_version "$INCREMENT_TYPE"
                echo ""
            else
                print_warning "Skipping version increment"
            fi
        elif [[ "$FLAVOR" == "development" ]]; then
            print_warning "Skipping version increment for development build"
        fi
        
        print_status "Building APK for '$FLAVOR'..."
        flutter build apk --flavor "$FLAVOR" -t "lib/main_${FLAVOR}.dart" --target-platform android-arm,android-arm64
        
        if [ $? -eq 0 ]; then
            print_success "APK built successfully!"
            echo ""
            
            # Rename the APK
            print_status "Renaming APK..."
            bash "$PROJECT_ROOT/bin/rename-apk.sh" "$FLAVOR"
            
        else
            print_error "Build failed!"
            exit 1
        fi
        ;;
    *)
        print_error "Invalid choice. Exiting..."
        exit 1
        ;;
esac