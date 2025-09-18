#include <QObject>
#include <QSignalSpy>
#include <QtTest/QtTest>
#include <qqmlvariantlistmodel.h>

class TestQQmlVariantListModel : public QObject {
    Q_OBJECT
  public:
    TestQQmlVariantListModel() : model(nullptr) {}

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
    void testReplace();
    void testMove();
    void testSwap();
    void testAppendList();
    void testPrependList();
    void testInsertList();
    void testSignals();
    void testRoles();

  private:
    QQmlVariantListModel *model;
};

void TestQQmlVariantListModel::initTestCase() {
    // Called before the first test function is executed
}

void TestQQmlVariantListModel::cleanupTestCase() {
    // Called after the last test function was executed
}

void TestQQmlVariantListModel::init() {
    model = new QQmlVariantListModel(this);
}

void TestQQmlVariantListModel::cleanup() {
    delete model;
    model = nullptr;
}

void TestQQmlVariantListModel::testEmpty() {
    QVERIFY(model != nullptr);
    QCOMPARE(model->count(), 0);
    QVERIFY(model->isEmpty());
    QCOMPARE(model->rowCount(), 0);
}

void TestQQmlVariantListModel::testAppend() {
    model->append(QVariant("test"));
    QCOMPARE(model->count(), 1);
    QVERIFY(!model->isEmpty());
    QCOMPARE(model->get(0).toString(), QString("test"));

    model->append(QVariant(42));
    QCOMPARE(model->count(), 2);
    QCOMPARE(model->get(1).toInt(), 42);
}

void TestQQmlVariantListModel::testPrepend() {
    model->append(QVariant("second"));
    model->prepend(QVariant("first"));

    QCOMPARE(model->count(), 2);
    QCOMPARE(model->get(0).toString(), QString("first"));
    QCOMPARE(model->get(1).toString(), QString("second"));
}

void TestQQmlVariantListModel::testInsert() {
    model->append(QVariant("first"));
    model->append(QVariant("third"));
    model->insert(1, QVariant("second"));

    QCOMPARE(model->count(), 3);
    QCOMPARE(model->get(0).toString(), QString("first"));
    QCOMPARE(model->get(1).toString(), QString("second"));
    QCOMPARE(model->get(2).toString(), QString("third"));
}

void TestQQmlVariantListModel::testRemove() {
    model->append(QVariant("first"));
    model->append(QVariant("second"));
    model->append(QVariant("third"));

    model->remove(1);
    QCOMPARE(model->count(), 2);
    QCOMPARE(model->get(0).toString(), QString("first"));
    QCOMPARE(model->get(1).toString(), QString("third"));
}

void TestQQmlVariantListModel::testClear() {
    model->append(QVariant("test1"));
    model->append(QVariant("test2"));
    QCOMPARE(model->count(), 2);

    model->clear();
    QCOMPARE(model->count(), 0);
    QVERIFY(model->isEmpty());
}

void TestQQmlVariantListModel::testGet() {
    model->append(QVariant("test"));
    QVariant value = model->get(0);
    QCOMPARE(value.toString(), QString("test"));

    // Test invalid index
    QVariant invalid = model->get(10);
    QVERIFY(!invalid.isValid());
}

void TestQQmlVariantListModel::testReplace() {
    model->append(QVariant("old"));
    model->replace(0, QVariant("new"));

    QCOMPARE(model->count(), 1);
    QCOMPARE(model->get(0).toString(), QString("new"));
}

void TestQQmlVariantListModel::testMove() {
    model->append(QVariant("first"));
    model->append(QVariant("second"));
    model->append(QVariant("third"));

    model->move(0, 2); // Move first to last position

    QCOMPARE(model->count(), 3);
    QCOMPARE(model->get(0).toString(), QString("second"));
    QCOMPARE(model->get(1).toString(), QString("third"));
    QCOMPARE(model->get(2).toString(), QString("first"));
}

void TestQQmlVariantListModel::testSwap() {
    model->append(QVariant("first"));
    model->append(QVariant("second"));
    model->append(QVariant("third"));

    model->swap(0, 2); // Swap first and third

    QCOMPARE(model->count(), 3);
    QCOMPARE(model->get(0).toString(), QString("third"));
    QCOMPARE(model->get(1).toString(), QString("second"));
    QCOMPARE(model->get(2).toString(), QString("first"));
}

void TestQQmlVariantListModel::testAppendList() {
    QVariantList list;
    list << "item1" << "item2" << "item3";

    model->appendList(list);

    QCOMPARE(model->count(), 3);
    QCOMPARE(model->get(0).toString(), QString("item1"));
    QCOMPARE(model->get(1).toString(), QString("item2"));
    QCOMPARE(model->get(2).toString(), QString("item3"));
}

void TestQQmlVariantListModel::testPrependList() {
    model->append(QVariant("existing"));

    QVariantList list;
    list << "item1" << "item2";

    model->prependList(list);

    QCOMPARE(model->count(), 3);
    QCOMPARE(model->get(0).toString(), QString("item1"));
    QCOMPARE(model->get(1).toString(), QString("item2"));
    QCOMPARE(model->get(2).toString(), QString("existing"));
}

void TestQQmlVariantListModel::testInsertList() {
    model->append(QVariant("first"));
    model->append(QVariant("last"));

    QVariantList list;
    list << "middle1" << "middle2";

    model->insertList(1, list);

    QCOMPARE(model->count(), 4);
    QCOMPARE(model->get(0).toString(), QString("first"));
    QCOMPARE(model->get(1).toString(), QString("middle1"));
    QCOMPARE(model->get(2).toString(), QString("middle2"));
    QCOMPARE(model->get(3).toString(), QString("last"));
}

void TestQQmlVariantListModel::testSignals() {
    QSignalSpy countSpy(model, &QQmlVariantListModel::countChanged);

    model->append(QVariant("test"));
    QCOMPARE(countSpy.count(), 1);
    QCOMPARE(countSpy.takeLast().at(0).toInt(), 1);

    model->clear();
    QCOMPARE(countSpy.count(), 1);
    QCOMPARE(countSpy.takeLast().at(0).toInt(), 0);
}

void TestQQmlVariantListModel::testRoles() {
    QHash<int, QByteArray> roles = model->roleNames();
    QVERIFY(roles.contains(Qt::DisplayRole));
}

QTEST_MAIN(TestQQmlVariantListModel)
// cppcheck-suppress missingInclude
#include "test_qqmlvariantlistmodel.moc"