!CONFIG(QT_QML_MODELS){
    # Qt QML Models
    CONFIG*=QT_QML_MODELS
    QT += core qml

    INCLUDEPATH += $$PWD

    HEADERS += \
        $$PWD/QQmlObjectListModel.h \
        $$PWD/QQmlVariantListModel.h

    SOURCES += \
        $$PWD/QQmlObjectListModel.cpp \
        $$PWD/QQmlVariantListModel.cpp

    include($$PWD/QtSuperMacros/QtSuperMacros.pri)
}
