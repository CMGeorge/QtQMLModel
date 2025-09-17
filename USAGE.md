# QtQMLModel - Usage Guide

QtQMLModel provides powerful and easy-to-use Qt/QML model classes for creating dynamic lists with automatic property binding and signal notification.

## Table of Contents

- [Overview](#overview)
- [QQmlVariantListModel](#qqmlvariantlistmodel)
- [QQmlObjectListModel](#qqmlobjectlistmodel)
- [QtSuperMacros](#qtsupermacros)
- [Build and Integration](#build-and-integration)
- [Examples](#examples)

## Overview

This library provides two main model classes that integrate seamlessly with Qt's Model/View architecture and QML:

1. **QQmlVariantListModel** - For lists of QVariant values (strings, numbers, booleans, etc.)
2. **QQmlObjectListModel** - For lists of QObject-derived custom objects with automatic property exposure

## QQmlVariantListModel

A versatile model for handling lists of QVariant values, perfect for simple data types.

### Features

- ✅ Automatic count property with change notifications
- ✅ Full Qt Model/View compatibility
- ✅ QML integration with automatic property binding
- ✅ Support for all QVariant-compatible types
- ✅ Rich manipulation API (append, prepend, insert, move, swap, etc.)
- ✅ Batch operations for better performance

### Basic Usage

```cpp
#include "qqmlvariantlistmodel.h"

// Create model
QQmlVariantListModel* model = new QQmlVariantListModel(this);

// Add items
model->append(QVariant("Hello"));
model->append(QVariant(42));
model->append(QVariant(true));

// Access items
QVariant item = model->get(0); // "Hello"
int count = model->count();    // 3

// Modify items
model->replace(1, QVariant(100));  // Replace 42 with 100
model->move(0, 2);                 // Move "Hello" to end
model->swap(0, 1);                 // Swap first two items
```

### QML Integration

```qml
import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    width: 400
    height: 600
    
    QQmlVariantListModel {
        id: listModel
        // Model automatically exposes 'count' property
    }
    
    ListView {
        anchors.fill: parent
        model: listModel
        
        delegate: Text {
            text: qtVariant  // Access variant data
            height: 40
        }
    }
    
    Button {
        text: "Add Item"
        onClicked: listModel.append("New Item " + listModel.count)
    }
}
```

### API Reference

#### Adding Items
```cpp
void append(const QVariant &item);               // Add to end
void prepend(const QVariant &item);              // Add to beginning
void insert(int idx, const QVariant &item);     // Insert at position

// Batch operations (more efficient)
void appendList(const QVariantList &itemList);  
void prependList(const QVariantList &itemList);
void insertList(int idx, const QVariantList &itemList);
```

#### Modifying Items
```cpp
void replace(int pos, const QVariant &item);    // Replace item at position
void move(int from, int to);                    // Move item (shifts others)
void swap(int idx1, int idx2);                  // Swap two items
void remove(int idx);                           // Remove item
void clear();                                   // Remove all items
```

#### Accessing Data
```cpp
QVariant get(int idx) const;                    // Get single item
QVariantList list() const;                      // Get all items as list
int count() const;                              // Get item count
bool isEmpty() const;                           // Check if empty
```

#### Signals
```cpp
void countChanged(int count);                   // Emitted when count changes
```

## QQmlObjectListModel

A template-based model for lists of custom QObject-derived objects with automatic property exposure.

### Features

- ✅ Template-based for type safety
- ✅ Automatic property exposure to QML based on Q_PROPERTY declarations
- ✅ Custom role names for property access
- ✅ Display role configuration
- ✅ UID-based lookups
- ✅ Same rich manipulation API as QQmlVariantListModel
- ✅ Automatic memory management

### Basic Usage

```cpp
// Define your custom object
class Person : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(int age READ age WRITE setAge NOTIFY ageChanged)

public:
    Person(QObject* parent = nullptr) : QObject(parent) {}
    
    QString name() const { return m_name; }
    void setName(const QString& name) {
        if (m_name != name) {
            m_name = name;
            emit nameChanged();
        }
    }
    
    int age() const { return m_age; }
    void setAge(int age) {
        if (m_age != age) {
            m_age = age;
            emit ageChanged();
        }
    }

signals:
    void nameChanged();
    void ageChanged();

private:
    QString m_name;
    int m_age = 0;
};

// Use with QQmlObjectListModel
QQmlObjectListModel<Person>* model = new QQmlObjectListModel<Person>(this);

// Add objects
Person* person1 = new Person();
person1->setName("Alice");
person1->setAge(30);
model->append(person1);

Person* person2 = new Person();
person2->setName("Bob");
person2->setAge(25);
model->append(person2);

// Access objects
Person* first = model->get(0);
int count = model->count();
```

### QML Integration

```qml
ListView {
    model: personModel // QQmlObjectListModel<Person>
    
    delegate: Column {
        Text { text: "Name: " + name }  // Direct property access
        Text { text: "Age: " + age }    // Properties auto-exposed
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                // Modify object properties directly
                age = age + 1
            }
        }
    }
}
```

### Advanced Configuration

```cpp
// Configure display role and UID
QQmlObjectListModel<Person>* model = new QQmlObjectListModel<Person>(
    this,                           // parent
    QByteArrayLiteral("name"),     // displayRole for Qt::DisplayRole
    QByteArrayLiteral("id")        // uidRole for unique identification
);
```

## QtSuperMacros

Convenient macros for reducing boilerplate code in QObject property declarations.

### Property Macros

```cpp
class MyObject : public QObject {
    Q_OBJECT
    
    // Read-write property with automatic getter/setter
    QML_WRITABLE_AUTO_PROPERTY(QString, title)
    
    // Read-only property
    QML_READONLY_AUTO_PROPERTY(int, itemCount)
    
    // Constant property (set once, never changes)
    QML_CONSTANT_AUTO_PROPERTY(QString, version)

public:
    MyObject(QObject* parent = nullptr) : QObject(parent) {
        // Initialize constant property
        m_version = "1.0.0";
    }
};
```

This generates:
- Private member variables (`m_title`, `m_itemCount`, `m_version`)
- Getter methods (`title()`, `itemCount()`, `version()`)
- Setter methods (for writable properties: `setTitle()`)
- Change notification signals (`titleChanged()`, `itemCountChanged()`)
- Q_PROPERTY declarations with appropriate attributes

## Build and Integration

### CMake Integration

```cmake
# Find the package
find_package(CPPQmlModels REQUIRED)

# Link to your target
target_link_libraries(your_target CPPQmlModels)
```

### QMake Integration

```pro
# Add to your .pro file
include(path/to/QtQMLModel/QtQMLModel.pri)
```

### Manual Integration

Simply include the source files in your project:
- `src/qqmlvariantlistmodel.h/cpp`
- `src/qqmlobjectlistmodel.h/cpp`
- `src/QtSuperMacros/*.h`

## Examples

### Example 1: Shopping List App

```cpp
// Create model
QQmlVariantListModel* shoppingList = new QQmlVariantListModel(this);

// Populate list
QVariantList items;
items << "Milk" << "Bread" << "Eggs" << "Butter";
shoppingList->appendList(items);

// Use in QML
engine.rootContext()->setContextProperty("shoppingList", shoppingList);
```

```qml
ListView {
    model: shoppingList
    delegate: CheckBox {
        text: qtVariant
        onToggled: {
            if (checked) {
                // Move completed item to end
                shoppingList.move(index, shoppingList.count - 1)
            }
        }
    }
}
```

### Example 2: Contact Manager

```cpp
class Contact : public QObject {
    Q_OBJECT
    QML_WRITABLE_AUTO_PROPERTY(QString, name)
    QML_WRITABLE_AUTO_PROPERTY(QString, email)
    QML_WRITABLE_AUTO_PROPERTY(QString, phone)
    QML_READONLY_AUTO_PROPERTY(QString, displayName)

public:
    Contact(QObject* parent = nullptr) : QObject(parent) {
        // Update display name when name changes
        connect(this, &Contact::nameChanged, this, [this]() {
            QString display = m_name.isEmpty() ? "Unknown" : m_name;
            if (m_displayName != display) {
                m_displayName = display;
                emit displayNameChanged();
            }
        });
    }
};

// Create and use model
QQmlObjectListModel<Contact>* contacts = new QQmlObjectListModel<Contact>(
    this, 
    QByteArrayLiteral("displayName")  // Use displayName for Qt::DisplayRole
);

// Add contacts
Contact* contact = new Contact();
contact->setName("John Doe");
contact->setEmail("john@example.com");
contacts->append(contact);
```

### Example 3: Dynamic Data Manipulation

```cpp
// Demonstrate various operations
QQmlVariantListModel* model = new QQmlVariantListModel(this);

// Add initial data
model->appendList({1, 2, 3, 4, 5});

// Move operations
model->move(0, 4);      // [2, 3, 4, 5, 1]

// Swap operations
model->swap(0, 4);      // [1, 3, 4, 5, 2]

// Batch insertions
model->prependList({"A", "B"});  // ["A", "B", 1, 3, 4, 5, 2]

// Replace operations
model->replace(2, "X"); // ["A", "B", "X", 3, 4, 5, 2]
```

## Performance Tips

1. **Use batch operations** (`appendList`, `prependList`, `insertList`) instead of multiple single operations
2. **Minimize property changes** - batch property updates when possible
3. **Use appropriate model size** - consider pagination for very large datasets
4. **Leverage QML property bindings** - let Qt handle updates automatically

## Thread Safety

⚠️ **Important**: These models are **not thread-safe**. All operations must be performed on the main/GUI thread. For multi-threaded applications, use Qt's signal-slot mechanism to communicate between threads.

## Migration Guide

If migrating from other list models:

- **From QStringListModel**: Replace with `QQmlVariantListModel` and convert strings to `QVariant`
- **From custom QAbstractListModel**: Use `QQmlObjectListModel<YourClass>` for better automatic property handling
- **From QML ListModel**: Direct replacement with better performance and C++ integration