#ifndef TESTOBJECT_H
#define TESTOBJECT_H

#include "qqmlmodels_global.h"
#include <QObject>
#include <QString>

// Test utility class for demonstrating QQmlObjectListModel usage
// This class is exported to ensure Windows DLL linking works correctly
class QQMLMODELS_EXPORT TestObject : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(int value READ value WRITE setValue NOTIFY valueChanged)

  public:
    explicit TestObject(QObject *parent = nullptr);
    TestObject(const QString &name, int value, QObject *parent = nullptr);

    QString name() const { return m_name; }
    void setName(const QString &name);

    int value() const { return m_value; }
    void setValue(int value);

  signals:
    void nameChanged();
    void valueChanged();

  private:
    QString m_name;
    int m_value;
};

#endif // TESTOBJECT_H