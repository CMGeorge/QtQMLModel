#!/bin/bash

# QtQMLModel Build Script
# Usage: ./scripts/build.sh [clean|release|debug|test|docs|format|lint]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_DIR/build"

echo "QtQMLModel Build Script"
echo "======================"
echo "Project directory: $PROJECT_DIR"
echo "Build directory: $BUILD_DIR"
echo ""

# Function to clean build directory
clean_build() {
    echo "Cleaning build directory..."
    rm -rf "$BUILD_DIR"
    echo "Clean complete."
}

# Function to configure and build
build_project() {
    local build_type=${1:-Release}
    echo "Building project (${build_type})..."
    
    mkdir -p "$BUILD_DIR"
    cd "$BUILD_DIR"
    
    cmake .. -DCMAKE_BUILD_TYPE="$build_type" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    make -j$(nproc)
    
    echo "Build complete."
}

# Function to run tests
run_tests() {
    echo "Running tests..."
    cd "$BUILD_DIR"
    ctest --output-on-failure
    echo "Tests complete."
}

# Function to generate documentation
generate_docs() {
    echo "Generating documentation..."
    cd "$PROJECT_DIR"
    doxygen docs/Doxyfile
    echo "Documentation generated in docs/html/"
}

# Function to format code
format_code() {
    echo "Formatting code..."
    cd "$PROJECT_DIR"
    find src/ tests/ -name "*.cpp" -o -name "*.h" | xargs clang-format -i
    echo "Code formatting complete."
}

# Function to run static analysis
run_lint() {
    echo "Running static analysis..."
    cd "$PROJECT_DIR"
    
    if [ ! -f "$BUILD_DIR/compile_commands.json" ]; then
        echo "compile_commands.json not found. Building first..."
        build_project
    fi
    
    echo "Running clang-tidy..."
    run-clang-tidy -p "$BUILD_DIR" src/ || true
    
    echo "Running cppcheck..."
    cppcheck --enable=all --error-exitcode=0 --inline-suppr \
        --suppress=missingIncludeSystem \
        --suppress=unusedFunction \
        src/ || true
    
    echo "Static analysis complete."
}

# Function to install dependencies
install_deps() {
    echo "Installing dependencies..."
    sudo apt update
    sudo apt install -y qt6-base-dev qt6-declarative-dev cmake build-essential \
        clang-format clang-tidy cppcheck doxygen graphviz
    echo "Dependencies installed."
}

# Function to create release package
create_package() {
    echo "Creating release package..."
    cd "$BUILD_DIR"
    cpack
    echo "Package created."
}

# Parse command line arguments
case "${1:-build}" in
    clean)
        clean_build
        ;;
    release)
        clean_build
        build_project "Release"
        ;;
    debug)
        clean_build
        build_project "Debug"
        ;;
    test)
        build_project
        run_tests
        ;;
    docs)
        generate_docs
        ;;
    format)
        format_code
        ;;
    lint)
        run_lint
        ;;
    deps)
        install_deps
        ;;
    package)
        build_project "Release"
        create_package
        ;;
    all)
        clean_build
        build_project "Release"
        run_tests
        generate_docs
        format_code
        run_lint
        ;;
    build)
        build_project
        ;;
    *)
        echo "Usage: $0 [clean|release|debug|test|docs|format|lint|deps|package|all|build]"
        echo ""
        echo "Commands:"
        echo "  clean    - Clean build directory"
        echo "  release  - Clean and build in Release mode"
        echo "  debug    - Clean and build in Debug mode"
        echo "  test     - Build and run tests"
        echo "  docs     - Generate documentation"
        echo "  format   - Format source code"
        echo "  lint     - Run static analysis"
        echo "  deps     - Install dependencies"
        echo "  package  - Create release package"
        echo "  all      - Run all operations"
        echo "  build    - Build project (default)"
        exit 1
        ;;
esac