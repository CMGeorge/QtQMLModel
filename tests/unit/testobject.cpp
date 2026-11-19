#include "testobject.h"

TestObject::TestObject(QObject *parent) : QObject(parent), m_value(0) {
}

TestObject::TestObject(const QString &name, int value, QObject *parent)
    : QObject(parent), m_name(name), m_value(value) {
}

void TestObject::setName(const QString &name) {
    if (m_name != name) {
        m_name = name;
        emit nameChanged();
    }
}

void TestObject::setValue(int value) {
    if (m_value != value) {
        m_value = value;
        emit valueChanged();
    }
}