# Qt QML Models

[![CI](https://github.com/CMGeorge/QtQMLModel/workflows/CI/badge.svg)](https://github.com/CMGeorge/QtQMLModel/actions)
[![License](https://img.shields.io/badge/license-MIT--like-blue.svg)](LICENSE.md)

Additional data models aimed to bring more power to QML applications by using useful C++ models in back-end.

## Features

* **`QQmlObjectListModel`**: A much nicer way to expose C++ list to QML than the quick & dirty `QList<QObject*>` property. Supports all the strong model features of `QAbstractListModel` while showing the simple and well know API of QList.

* **`QQmlVariantListModel`**: A dead-simple way to create a dynamic C++ list of any type and expose it to QML, way better than using a `QVariantList` property.

* **Qt Super Macros**: Powerful macros for property declaration that reduce boilerplate code:
  - `QML_WRITABLE_AUTO_PROPERTY` - Creates a full read/write property with getter, setter, and change signal
  - `QML_READONLY_AUTO_PROPERTY` - Creates a read-only property with getter and change signal
  - `QML_CONSTANT_AUTO_PROPERTY` - Creates a constant property with only a getter

## Requirements

- Qt 6.8 or later
- CMake 3.22 or later
- C++17 compatible compiler

## Quick Start

### Building from Source

```bash
# Clone the repository
git clone https://github.com/CMGeorge/QtQMLModel.git
cd QtQMLModel

# Install dependencies (Ubuntu/Debian)
sudo apt install qt6-base-dev qt6-declarative-dev cmake build-essential

# Build the project
./scripts/build.sh release

# Run tests
./scripts/build.sh test
```

### Using in Your Project

#### CMake Integration (Recommended)

The primary and recommended way to integrate QtQMLModel is using CMake:

```cmake
find_package(CPPQmlModels REQUIRED)
target_link_libraries(your_target PRIVATE CPPQmlModels::CPPQmlModels)
```

#### QMake Integration (Legacy)

> **Note**: QMake files are preserved for compatibility but are not actively maintained. CMake is the recommended build system.

```qmake
include(path/to/QtQMLModel.pri)
```

## Usage Examples

### QQmlObjectListModel

```cpp
#include <qqmlobjectlistmodel.h>

class Person : public QObject {
    Q_OBJECT
    QML_WRITABLE_AUTO_PROPERTY(QString, name)
    QML_WRITABLE_AUTO_PROPERTY(int, age)
public:
    explicit Person(QObject* parent = nullptr) : QObject(parent) {}
};

// In your C++ code
auto model = new QQmlObjectListModel<Person>(this);
model->append(new Person);
model->get(0)->set_name("John Doe");
model->get(0)->set_age(30);

// Register with QML
qmlRegisterType<QQmlObjectListModel<Person>>("MyApp", 1, 0, "PersonModel");
```

```qml
// In your QML file
import MyApp 1.0

ListView {
    model: PersonModel {
        id: personModel
    }
    delegate: Text {
        text: model.name + " (" + model.age + ")"
    }
}
```

### QQmlVariantListModel

```cpp
#include <qqmlvariantlistmodel.h>

// In your C++ code
auto model = new QQmlVariantListModel(this);
model->append("First item");
model->append(42);
model->append(true);

// Register with QML
qmlRegisterType<QQmlVariantListModel>("MyApp", 1, 0, "VariantListModel");
```

### Qt Super Macros

```cpp
#include <qqmlautopropertyhelpers.h>

class MyClass : public QObject {
    Q_OBJECT
    
    QML_WRITABLE_AUTO_PROPERTY(QString, title)
    QML_READONLY_AUTO_PROPERTY(int, count)
    QML_CONSTANT_AUTO_PROPERTY(QString, version)
    
public:
    explicit MyClass(QObject* parent = nullptr) : QObject(parent) {
        m_title = "Default Title";
        m_count = 0;
        m_version = "1.0";
    }
    
    void incrementCount() {
        update_count(m_count + 1); // Use update_ for readonly properties
    }
};
```

## Development

### Building and Testing

```bash
# Build in debug mode
./scripts/build.sh debug

# Run all tests
./scripts/build.sh test

# Generate documentation
./scripts/build.sh docs

# Format code
./scripts/build.sh format

# Run static analysis
./scripts/build.sh lint

# Run everything
./scripts/build.sh all
```

### Code Quality Tools

The project uses several tools to maintain code quality:

- **clang-format**: Code formatting (configured in `.clang-format`)
- **clang-tidy**: Static analysis (configured in `.clang-tidy`)
- **cppcheck**: Additional static analysis
- **Doxygen**: API documentation generation

### Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes and add tests
4. Run the full test suite: `./scripts/build.sh all`
5. Commit your changes: `git commit -am 'Add some feature'`
6. Push to the branch: `git push origin feature/my-feature`
7. Submit a pull request

#### Code Style

- Follow the existing code style (enforced by clang-format)
- Add documentation for public APIs
- Include unit tests for new functionality
- Ensure all tests pass before submitting

### Release Management

#### Creating a Release

1. Update version numbers in:
   - `CMakeLists.txt`
   - `qpm.json`
   - Documentation

2. Update `CHANGELOG.md` with release notes

3. Create and push a version tag:
   ```bash
   git tag -a v1.1.0 -m "Release version 1.1.0"
   git push origin v1.1.0
   ```

4. GitHub Actions will automatically create a release with artifacts

#### Hotfix Process

For critical bug fixes:

1. Create a hotfix branch from the latest release tag:
   ```bash
   git checkout -b hotfix/v1.0.1 v1.0.0
   ```

2. Make the minimal necessary changes
3. Test thoroughly
4. Update version numbers
5. Create a new tag and push

## API Documentation

Full API documentation is available at: [Documentation Link](docs/html/index.html)

Generate locally with:
```bash
./scripts/build.sh docs
```

## License

This project uses a very permissive license similar to WTFPL. See [LICENSE.md](LICENSE.md) for details.

Basically:
- Use it however you want (submodule, shared library, modifications, etc.)
- No attribution required (but appreciated)
- Share improvements if you want (but not required)
- Do whatever makes sense for your project

## Support

- **Issues**: [GitHub Issues](https://github.com/CMGeorge/QtQMLModel/issues)
- **Discussions**: [GitHub Discussions](https://github.com/CMGeorge/QtQMLModel/discussions)
- **Email**: george@wesell.ro

## Acknowledgments

Original Qt QML Models project by the Qt community and contributors.

---

> **Note**: If you want to donate, use this link: [![Flattr this](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=thebootroo&url=http://gitlab.unique-conception.org/qt-qml-tricks/qt-qml-models)
