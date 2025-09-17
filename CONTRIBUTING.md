# Contributing to QtQMLModel

Thank you for your interest in contributing to QtQMLModel! This document provides guidelines and information for contributors.

## Development Setup

### Prerequisites

- Qt 6.7.2 or later
- CMake 3.22 or later
- C++17 compatible compiler (GCC 7+, Clang 5+, MSVC 2017+)
- Git

### Setting Up the Development Environment

1. Fork and clone the repository:
   ```bash
   git clone https://github.com/your-username/QtQMLModel.git
   cd QtQMLModel
   ```

2. Install dependencies:
   ```bash
   # Ubuntu/Debian
   sudo apt install qt6-base-dev qt6-declarative-dev cmake build-essential \
       clang-format clang-tidy cppcheck doxygen graphviz

   # Or use the script
   ./scripts/build.sh deps
   ```

3. Build and test:
   ```bash
   ./scripts/build.sh all
   ```

## Development Workflow

### Making Changes

1. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes following the coding standards
3. Add tests for new functionality
4. Run the full test suite:
   ```bash
   ./scripts/build.sh all
   ```

5. Commit your changes:
   ```bash
   git commit -am "Add feature: your feature description"
   ```

6. Push and create a pull request

### Coding Standards

#### Code Style

- Follow the existing code style (enforced by `.clang-format`)
- Use 4 spaces for indentation (no tabs)
- Maximum line length: 100 characters
- Use camelCase for functions and variables
- Use PascalCase for classes
- Use UPPER_CASE for macros and constants
- Prefix private members with `m_`

#### Documentation

- Document all public APIs using Doxygen-style comments
- Include usage examples for complex functionality
- Update README.md for significant changes
- Add entries to CHANGELOG.md

#### Example of well-documented code:

```cpp
/**
 * @brief Appends an item to the end of the model
 * 
 * This function adds the specified item to the end of the model and emits
 * the appropriate signals to notify views of the change.
 * 
 * @param item The item to append (takes ownership)
 * 
 * Example usage:
 * @code
 * auto model = new QQmlObjectListModel<Person>(this);
 * auto person = new Person("John", 30);
 * model->append(person);
 * @endcode
 */
void append(ItemType* item);
```

### Testing

#### Running Tests

```bash
# Run all tests
./scripts/build.sh test

# Run specific test
cd build
./tests/unit/test_qqmlvariantlistmodel
```

#### Writing Tests

- Add unit tests for all new functionality
- Use Qt Test framework
- Follow the existing test structure in `tests/unit/`
- Test both success and failure cases
- Include edge cases and boundary conditions

#### Test Structure

```cpp
class TestMyFeature : public QObject
{
    Q_OBJECT

private slots:
    void initTestCase();    // Called before first test
    void init();           // Called before each test
    void testBasicFunctionality();
    void testEdgeCases();
    void cleanup();        // Called after each test
    void cleanupTestCase(); // Called after last test
};
```

### Code Quality

The project uses several tools to maintain code quality:

#### Automated Formatting

```bash
# Format all source files
./scripts/build.sh format

# Check formatting without modifying files
find src/ tests/ -name "*.cpp" -o -name "*.h" | xargs clang-format --dry-run --Werror
```

#### Static Analysis

```bash
# Run all static analysis tools
./scripts/build.sh lint
```

#### Tools Used

- **clang-format**: Automatic code formatting
- **clang-tidy**: Static analysis and modernization  
- **cppcheck**: Additional static analysis with Qt support
- **Doxygen**: Documentation generation

#### Cppcheck Qt Configuration

The project includes special configuration for cppcheck to properly handle Qt-specific keywords and macros. This prevents false "unknownMacro" warnings for Qt code patterns.

**Configured Qt Keywords:**
- `slots`, `signals` - Qt access specifiers
- `Q_OBJECT`, `Q_GADGET` - Qt meta-object system
- `Q_PROPERTY`, `Q_EMIT` - Qt property and signal system
- `Q_SIGNALS`, `Q_SLOTS` - Qt macro equivalents
- Project-specific macros: `QQML_EXPORT`, `MAKE_GETTER_NAME`, etc.

**Local Development:**
```bash
# Run cppcheck with Qt configuration
./scripts/build.sh lint

# Manual cppcheck with Qt support
cppcheck --enable=all --define=slots= --define=signals=public --define=Q_OBJECT= src/
```

**CI/CD Integration:**
The GitHub Actions workflow automatically runs cppcheck with full Qt macro definitions, ensuring all Qt-specific code patterns are properly recognized and analyzed.

### Continuous Integration

The project uses GitHub Actions for CI/CD:

- **Build**: Tests compilation on Ubuntu, Windows, and macOS
- **Test**: Runs the complete test suite
- **Code Quality**: Checks formatting and runs static analysis
- **Documentation**: Generates and publishes API documentation
- **Release**: Automatically creates releases for tagged versions

### Release Process

#### Version Numbering

We follow [Semantic Versioning](https://semver.org/):

- **MAJOR**: Incompatible API changes
- **MINOR**: New functionality (backwards compatible)
- **PATCH**: Bug fixes (backwards compatible)

#### Creating a Release

1. Update version numbers:
   - `CMakeLists.txt` (PROJECT_VERSION)
   - `qpm.json` (version.label)

2. Update `CHANGELOG.md`:
   - Move unreleased changes to new version section
   - Add release date
   - Create new unreleased section

3. Create and push tag:
   ```bash
   git tag -a v1.2.0 -m "Release version 1.2.0"
   git push origin v1.2.0
   ```

4. GitHub Actions will automatically:
   - Build release binaries
   - Create GitHub release
   - Upload artifacts

#### Hotfix Process

For critical bugs in released versions:

1. Create hotfix branch from release tag:
   ```bash
   git checkout -b hotfix/v1.1.1 v1.1.0
   ```

2. Make minimal necessary changes
3. Update version and changelog
4. Test thoroughly
5. Create new tag and push

### Issue Guidelines

#### Reporting Bugs

When reporting bugs, please include:

- Qt version
- Operating system and version
- Compiler and version
- Minimal example that reproduces the issue
- Expected vs actual behavior
- Any error messages or stack traces

#### Feature Requests

For feature requests:

- Describe the use case and motivation
- Provide examples of how the feature would be used
- Consider backwards compatibility
- Be open to alternative solutions

#### Templates

Use the provided issue templates when available.

## Community

### Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and improve
- Maintain a professional attitude

### Communication

- **Issues**: For bug reports and feature requests
- **Discussions**: For questions and general discussion
- **Pull Requests**: For code contributions
- **Email**: george@wesell.ro for direct contact

### Recognition

Contributors are acknowledged in:

- Git commit history
- Release notes
- Documentation credits
- Project README

Thank you for contributing to QtQMLModel!