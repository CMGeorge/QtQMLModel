#include <QtTest>

// add necessary includes here

#include "../../../src/qqmlobjectlistmodel.h"

class ItemTest:public QObject{
    Q_OBJECT
};

class DLLImportExport : public QObject
{
    Q_OBJECT
    QML_OBJMODEL_PROPERTY(ItemTest,
                          testItemModel)

public:
    DLLImportExport();
    ~DLLImportExport();

private slots:
    void test_case1();

};

DLLImportExport::DLLImportExport()
{
    m_testItemModel = new QQmlObjectListModel<ItemTest>(this);
}

DLLImportExport::~DLLImportExport()
{

}

void DLLImportExport::test_case1()
{

}

QTEST_APPLESS_MAIN(DLLImportExport)

#include "tst_dllimportexport.moc"
