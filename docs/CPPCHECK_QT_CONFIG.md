# Cppcheck Qt Configuration

This document explains how cppcheck is configured to work with Qt code in this project.

## Problem

By default, cppcheck doesn't understand Qt-specific keywords and macros, leading to "unknownMacro" warnings such as:

```
error: There is an unknown macro here somewhere. Configuration is required. 
If slots is a macro then please configure it. [unknownMacro]
  public slots: // public API
```

## Solution

The project configures cppcheck to recognize Qt keywords and macros through `--define` options.

## Qt Keywords Configured

### Access Specifiers
- `slots` → defined as empty (becomes regular public/protected/private)
- `signals` → defined as `public`
- `Q_SLOTS` → defined as empty 
- `Q_SIGNALS` → defined as `public`

### Meta-Object System
- `Q_OBJECT` → defined as empty
- `Q_GADGET` → defined as empty
- `Q_NAMESPACE` → defined as empty

### Property System  
- `Q_PROPERTY(x)` → defined as empty
- `Q_EMIT` → defined as empty
- `emit` → defined as empty

### Common Macros
- `Q_NULLPTR` → defined as `nullptr`
- `Q_OVERRIDE` → defined as `override`
- `Q_FINAL` → defined as `final`

### Project-Specific Macros
- `QQML_EXPORT` → defined as empty
- `MAKE_GETTER_NAME(name)` → defined as `get##name`
- `QML_WRITABLE_AUTO_PROPERTY(type,name)` → defined as empty
- `QML_READONLY_AUTO_PROPERTY(type,name)` → defined as empty
- `QML_CONSTANT_AUTO_PROPERTY(type,name)` → defined as empty

## Usage

### Local Development

```bash
# Use the build script (recommended)
./scripts/build.sh lint

# Manual cppcheck with Qt support
cppcheck \
  --enable=all \
  -Dslots= \
  -Dsignals=public \
  -DQ_OBJECT= \
  -DQ_SIGNALS=public \
  -DQ_SLOTS= \
  -DQ_EMIT= \
  -D"Q_PROPERTY(x)=" \
  -DQ_NULLPTR=nullptr \
  -DQQML_EXPORT= \
  -D"MAKE_GETTER_NAME(name)=get##name" \
  src/
```

### CI/CD Integration

The GitHub Actions workflow (`.github/workflows/ci.yml`) includes the same configuration automatically:

```yaml
- name: Cppcheck
  run: |
    cppcheck \
      --enable=all \
      --error-exitcode=1 \
      --inline-suppr \
      -Dslots= \
      -Dsignals=public \
      # ... (full configuration)
      src/
```

## Adding New Qt Macros

If you encounter new "unknownMacro" warnings for Qt keywords:

1. **Update the build script**: Add the new `--define` option to `scripts/build.sh`
2. **Update the CI workflow**: Add the same option to `.github/workflows/ci.yml`
3. **Update this documentation**: Document the new macro in the appropriate section above

### Example

For a new Qt macro `Q_CUSTOM_MACRO(x)`:

```bash
# Add to both build script and CI workflow
-D"Q_CUSTOM_MACRO(x)="
```

## Suppressed Warnings

Some warnings are suppressed as they're common in Qt projects:

- `unusedFunction` - Qt MOC generates functions that may appear unused
- `missingIncludeSystem` - Qt headers sometimes have complex include patterns
- `unusedStructMember` - Qt properties may generate unused private members

## Best Practices

1. **Keep macros minimal**: Only define what's necessary to avoid warnings
2. **Test locally**: Run `./scripts/build.sh lint` before committing
3. **Document additions**: Update this file when adding new macro definitions
4. **Consistent configuration**: Ensure build script and CI use identical settings

## References

- [Cppcheck Manual](https://cppcheck.sourceforge.io/manual.html)
- [Qt Documentation - Using Qt from cmake](https://doc.qt.io/qt-6/cmake-get-started.html)
- [Qt Meta-Object System](https://doc.qt.io/qt-6/metaobjects.html)