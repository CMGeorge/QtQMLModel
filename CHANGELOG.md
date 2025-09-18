# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive CMake build system with proper installation and packaging
- GitHub Actions CI/CD pipeline for automated testing and releases
- Complete test suite with unit tests for all major components
- Doxygen documentation generation
- Code quality tools (clang-format, clang-tidy, cppcheck)
- Development scripts for building, testing, and maintenance
- Detailed README with usage examples and development guidelines
- Professional project structure with proper export headers

### Changed
- Migrated to modern CMake as primary build system (QMake files preserved as legacy)
- Updated CMakeLists.txt to support Qt6 and proper library installation
- **Updated CI/CD pipeline to use Qt 6.7.2 (compatible with install-qt-action)**
- Improved .gitignore to exclude build artifacts
- Enhanced project structure for better maintainability

### Fixed
- Qt6 compatibility issues
- Build system improvements for cross-platform support
- Header include paths and export definitions
- **Updated deprecated GitHub Actions (upload-artifact@v3 to v4, cache@v3 to v4)**
- **Replaced Q_SLOTS with slots to fix cppcheck unknown macro warnings**
- **Configured cppcheck to properly recognize Qt keywords and macros**
- **Fixed cppcheck command line syntax (-D instead of --define=)**

## [1.0.0] - Previous Release

### Added
- QQmlObjectListModel for exposing C++ object lists to QML
- QQmlVariantListModel for dynamic variant lists in QML
- Qt Super Macros for property declarations
- Basic QMake build system
- GitLab CI configuration

### Features
- Template-based QQmlObjectListModel with type safety
- Dynamic QQmlVariantListModel with variant support
- Comprehensive property macros (writable, readonly, constant)
- Cross-platform compatibility
- QML integration ready