#!/bin/bash

# Install development tools and git hooks for QtQMLModel

echo "Setting up QtQMLModel development environment..."

# Install git hooks
if [ -d ".git" ]; then
    echo "Installing git hooks..."
    
    # Install pre-commit hook
    cp scripts/pre-commit .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
    echo "✓ Pre-commit hook installed"
    
    # Install pre-push hook
    cp scripts/pre-push .git/hooks/pre-push
    chmod +x .git/hooks/pre-push
    echo "✓ Pre-push hook installed"
else
    echo "Warning: Not a git repository, skipping git hooks"
fi

# Install dependencies if on supported platform
if command -v apt &> /dev/null; then
    echo "Installing dependencies (requires sudo)..."
    ./scripts/build.sh deps
elif command -v brew &> /dev/null; then
    echo "Installing dependencies with Homebrew..."
    brew install qt cmake doxygen graphviz clang-format
elif command -v pacman &> /dev/null; then
    echo "Installing dependencies with pacman..."
    sudo pacman -S qt6-base qt6-declarative cmake doxygen graphviz clang
else
    echo "Unknown package manager. Please install dependencies manually:"
    echo "- Qt 6.7.2+"
    echo "- CMake 3.22+"
    echo "- Doxygen"
    echo "- Graphviz"
    echo "- clang-format, clang-tidy, cppcheck"
fi

# Run initial build and test
echo "Running initial build and test..."
./scripts/build.sh all

echo ""
echo "Development environment setup complete!"
echo ""
echo "Next steps:"
echo "1. Read CONTRIBUTING.md for development guidelines"
echo "2. Create a feature branch: git checkout -b feature/my-feature"
echo "3. Make your changes and commit (pre-commit hook will run automatically)"
echo "4. Push and create a pull request"
echo ""
echo "Available commands:"
echo "./scripts/build.sh [clean|release|debug|test|docs|format|lint|all]"