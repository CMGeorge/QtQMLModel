#ifndef QQMLVARPROPERTYHELPERS
#define QQMLVARPROPERTYHELPERS

#include <QObject>

#include "qqmlhelperscommon.h"

#define QML_WRITABLE_VAR_PROPERTY(type, name) \
protected: \
    Q_PROPERTY (type name READ MAKE_GETTER_NAME (name) WRITE set_##name NOTIFY name##Changed) \
    private: \
    type m_##name; \
    public: \
    type MAKE_GETTER_NAME (name) (void) const { \
        return m_##name ; \
} \
    public Q_SLOTS: \
    bool set_##name (type name) { \
        bool ret = false; \
        if ((ret = (m_##name != name))) { \
            m_##name = name; \
            Q_EMIT name##Changed (m_##name); \
    } \
        return ret; \
} \
    Q_SIGNALS: \
    void name##Changed (type name); \
    private:
#define QML_WRITABLE_VAR_PROPERTY_MODIFIED(type, name)                         \
protected:                                                                     \
    Q_PROPERTY(type name READ MAKE_GETTER_NAME(name)                           \
                   WRITE set_##name NOTIFY name##Changed)                      \
    Q_PROPERTY(bool name##ErrorId READ MAKE_GETTER_NAME(name##ErrorId)         \
                   NOTIFY name##ErrorIdChanged)                                \
private:                                                                       \
    type m_##name;                                                             \
    type m_##name##_initial;                                                   \
    bool m_##name##_modified = false;                                          \
    int m_##name##ErrorId = 0;                                                 \
                                                                               \
public:                                                                        \
    type MAKE_GETTER_NAME(name)(void) const { return m_##name; }               \
    int MAKE_GETTER_NAME(name##ErrorId)(void) const {                         \
        return m_##name##ErrorId;                                              \
    }\
    bool update_##name##ErrorId(int name##ErrorId) {                     \
        bool ret = false;                                                      \
        if ((ret = (m_##name##ErrorId != name##ErrorId))) {                    \
            m_##name##ErrorId = name##ErrorId;                                 \
            emit name##ErrorIdChanged(m_##name##ErrorId);                       \
        }                                                                      \
    return ret;                                                            \
    }\
public Q_SLOTS:                                                                \
    bool set_##name(type name) {                                               \
        bool ret = false;                                                      \
        if ((ret = (m_##name != name))) {                                      \
            m_##name = name;                                                   \
            emit name##Changed(m_##name);                                      \
            if (!m_##name##_modified) {                                        \
                m_##name##_modified = true;                                    \
                emit name##Modified(m_##name);                                 \
            } else if (m_##name##_initial == m_##name) {                       \
                m_##name##_modified = false;                                   \
                emit name##Modified(m_##name);                                 \
            }                                                                  \
update_##name##ErrorId(0);                                                       \
        }                                                                      \
        return ret;                                                            \
    }                                                                          \
    bool init_##name(type name) {                                              \
        bool ret = false;                                                      \
        m_##name##_modified = false;                                           \
        m_##name##_initial = name;                                             \
        if ((ret = (m_##name != name))) {                                      \
            m_##name = name;                                                   \
            emit name##Changed(m_##name);                                      \
        }                                                                      \
        return ret;                                                            \
    }                                                                          \
                                                                         \
Q_SIGNALS:                                                                     \
    void name##Changed(type name);                                             \
    void name##Modified(type name);                                            \
    void name##ErrorIdChanged(bool name##ErrorId);\
private:

#define QML_READONLY_VAR_PROPERTY(type, name) \
              protected: \
    Q_PROPERTY (type name READ MAKE_GETTER_NAME (name) NOTIFY name##Changed) \
    private: \
    type m_##name; \
    public: \
    type MAKE_GETTER_NAME (name) (void) const { \
        return m_##name ; \
} \
    bool update_##name (type name) { \
        bool ret = false; \
        if ((ret = (m_##name != name))) { \
            m_##name = name; \
            Q_EMIT name##Changed (m_##name); \
    } \
        return ret; \
} \
    Q_SIGNALS: \
    void name##Changed (type name); \
    private:

#define QML_CONSTANT_VAR_PROPERTY(type, name) \
              protected: \
    Q_PROPERTY (type name READ MAKE_GETTER_NAME (name) CONSTANT) \
    private: \
    type m_##name; \
    public: \
    type MAKE_GETTER_NAME (name) (void) const { \
        return m_##name ; \
} \
    private:

              class _QmlVarProperty_ : public QObject {
    Q_OBJECT
    QML_WRITABLE_VAR_PROPERTY (int,     var1)
        QML_READONLY_VAR_PROPERTY (bool,    var2)
        QML_CONSTANT_VAR_PROPERTY (QString, var3)
};

#endif // QQMLVARPROPERTYHELPERS
