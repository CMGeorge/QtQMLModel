#include <QObject>
#include <QSignalSpy>
#include <QtTest/QtTest>
#include <qqmlobjectlistmodel.h>
#include <testobject.h>

class TestQQmlObjectListModel : public QObject {
    Q_OBJECT
  public:
    TestQQmlObjectListModel() : model(nullptr) {}

  private slots:
    void initTestCase();
    void cleanupTestCase();
    void init();
    void cleanup();

    void testEmpty();
    void testAppend();
    void testPrepend();
    void testInsert();
    void testRemove();
    void testClear();
    void testGet();
    void testIndexOf();
    void testContains();
    void testRoles();
    void testData();
    void testSignals();

  private:
    QQmlObjectListModel<TestObject> *model;
};

void TestQQmlObjectListModel::initTestCase() {
    // Called before the first test function is executed
}

void TestQQmlObjectListModel::cleanupTestCase() {
    // Called after the last test function was executed
}

void TestQQmlObjectListModel::init() {
    model = new QQmlObjectListModel<TestObject>(this);
}

void TestQQmlObjectListModel::cleanup() {
    delete model;
    model = nullptr;
}

void TestQQmlObjectListModel::testEmpty() {
    QVERIFY(model != nullptr);
    QCOMPARE(model->count(), 0);
    QCOMPARE(model->size(), 0);
    QVERIFY(model->isEmpty());
    // Don't test protected rowCount() directly
}

void TestQQmlObjectListModel::testAppend() {
    TestObject *obj = new TestObject("test", 42);
    model->append(obj);

    QCOMPARE(model->count(), 1);
    QCOMPARE(model->size(), 1);
    QVERIFY(!model->isEmpty());
    QCOMPARE(model->get(0), obj);
}

void TestQQmlObjectListModel::testPrepend() {
    TestObject *obj1 = new TestObject("first", 1);
    TestObject *obj2 = new TestObject("second", 2);

    model->append(obj2);
    model->prepend(obj1);

    QCOMPARE(model->count(), 2);
    QCOMPARE(model->get(0), obj1);
    QCOMPARE(model->get(1), obj2);
}

void TestQQmlObjectListModel::testInsert() {
    TestObject *obj1 = new TestObject("first", 1);
    TestObject *obj2 = new TestObject("second", 2);
    TestObject *obj3 = new TestObject("third", 3);

    model->append(obj1);
    model->append(obj3);
    model->insert(1, obj2);

    QCOMPARE(model->count(), 3);
    QCOMPARE(model->get(0), obj1);
    QCOMPARE(model->get(1), obj2);
    QCOMPARE(model->get(2), obj3);
}

void TestQQmlObjectListModel::testRemove() {
    TestObject *obj1 = new TestObject("first", 1);
    TestObject *obj2 = new TestObject("second", 2);
    TestObject *obj3 = new TestObject("third", 3);

    model->append(obj1);
    model->append(obj2);
    model->append(obj3);

    model->remove(1);
    QCOMPARE(model->count(), 2);
    QCOMPARE(model->get(0), obj1);
    QCOMPARE(model->get(1), obj3);
}

void TestQQmlObjectListModel::testClear() {
    TestObject *obj1 = new TestObject("first", 1);
    TestObject *obj2 = new TestObject("second", 2);

    model->append(obj1);
    model->append(obj2);
    QCOMPARE(model->count(), 2);

    model->clear();
    QCOMPARE(model->count(), 0);
    QVERIFY(model->isEmpty());
}

void TestQQmlObjectListModel::testGet() {
    TestObject *obj = new TestObject("test", 42);
    model->append(obj);

    QCOMPARE(model->get(0), obj);
    QCOMPARE(model->get(10), nullptr); // Invalid index
}

void TestQQmlObjectListModel::testIndexOf() {
    TestObject *obj1 = new TestObject("first", 1);
    TestObject *obj2 = new TestObject("second", 2);
    TestObject *obj3 = new TestObject("third", 3);

    model->append(obj1);
    model->append(obj2);

    QCOMPARE(model->indexOf(obj1), 0);
    QCOMPARE(model->indexOf(obj2), 1);
    QCOMPARE(model->indexOf(obj3), -1); // Not in model
}

void TestQQmlObjectListModel::testContains() {
    TestObject *obj1 = new TestObject("first", 1);
    TestObject *obj2 = new TestObject("second", 2);

    model->append(obj1);

    QVERIFY(model->contains(obj1));
    QVERIFY(!model->contains(obj2));
}

void TestQQmlObjectListModel::testRoles() {
    QHash<int, QByteArray> roles = model->roleNames();
    QVERIFY(roles.size() > 0);
    // The exact roles depend on the TestObject properties
}

void TestQQmlObjectListModel::testData() {
    TestObject *obj = new TestObject("test", 42);
    model->append(obj);

    QModelIndex index = model->index(0, 0);
    QVERIFY(index.isValid());

    // Test data retrieval for different roles
    QVariant data = model->data(index, Qt::DisplayRole);
    QVERIFY(data.isValid());
}

void TestQQmlObjectListModel::testSignals() {
    QSignalSpy countSpy(model, &QQmlObjectListModelBase::countChanged);

    TestObject *obj = new TestObject("test", 42);
    model->append(obj);

    QCOMPARE(countSpy.count(), 1);

    model->clear();
    QCOMPARE(countSpy.count(), 2);
}

QTEST_MAIN(TestQQmlObjectListModel)
// cppcheck-suppress missingInclude
#include "test_qqmlobjectlistmodel.moc"