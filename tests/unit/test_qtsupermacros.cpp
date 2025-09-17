#include <QObject>
#include <QSignalSpy>
#include <QtTest/QtTest>
#include <qqmlautopropertyhelpers.h>

// Test class using the macros (must be at global scope for MOC)
class TestPropertyClass : public QObject {
    Q_OBJECT

    QML_WRITABLE_AUTO_PROPERTY(QString, writableProp)
    QML_READONLY_AUTO_PROPERTY(int, readonlyProp)
    QML_CONSTANT_AUTO_PROPERTY(bool, constantProp)

  public:
    explicit TestPropertyClass(QObject *parent = nullptr)
        : QObject(parent), m_writableProp(QString("initial")), m_readonlyProp(42),
          m_constantProp(true) {}

    // For readonly property, we need to provide a way to update it
    void updateReadonly(int value) { update_readonlyProp(value); }
};

class TestQtSuperMacros : public QObject {
    Q_OBJECT

  private slots:
    void initTestCase();
    void cleanupTestCase();
    void testWritableProperty();
    void testReadonlyProperty();
    void testConstantProperty();
};

void TestQtSuperMacros::initTestCase() {
    // Called before the first test function is executed
}

void TestQtSuperMacros::cleanupTestCase() {
    // Called after the last test function was executed
}

void TestQtSuperMacros::testWritableProperty() {
    TestPropertyClass obj;

    // Test initial value
    QCOMPARE(obj.get_writableProp(), QString("initial"));

    // Test signal spy
    QSignalSpy spy(&obj, &TestPropertyClass::writablePropChanged);

    // Test setter
    bool result = obj.set_writableProp("new value");
    QVERIFY(result); // Should return true when value changes
    QCOMPARE(obj.get_writableProp(), QString("new value"));
    QCOMPARE(spy.count(), 1);

    // Test setting same value (should not emit signal)
    result = obj.set_writableProp("new value");
    QVERIFY(!result);         // Should return false when value doesn't change
    QCOMPARE(spy.count(), 1); // Signal count should remain the same
}

void TestQtSuperMacros::testReadonlyProperty() {
    TestPropertyClass obj;

    // Test initial value
    QCOMPARE(obj.get_readonlyProp(), 42);

    // Test signal spy
    QSignalSpy spy(&obj, &TestPropertyClass::readonlyPropChanged);

    // Test updater (readonly properties use update_ prefix)
    obj.updateReadonly(100);
    QCOMPARE(obj.get_readonlyProp(), 100);
    QCOMPARE(spy.count(), 1);
}

void TestQtSuperMacros::testConstantProperty() {
    TestPropertyClass obj;

    // Test constant value
    QCOMPARE(obj.get_constantProp(), true);

    // Constant properties don't have setters or signals
    // They should be accessible via getter only
}

QTEST_MAIN(TestQtSuperMacros)
// cppcheck-suppress missingInclude
#include "test_qtsupermacros.moc"