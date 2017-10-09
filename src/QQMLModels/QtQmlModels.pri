#!CONFIG(QT_QML_MODELS){
    # Qt QML Models
#    CONFIG*=QT_QML_MODELS
    QT += core qml

    INCLUDEPATH += $$PWD

    SOURCES += \
    $$PWD/qqmlobjectlistmodel.cpp \
    $$PWD/qqmlvariantlistmodel.cpp

    include($$PWD/QtSuperMacros/QtSuperMacros.pri)

HEADERS += \
            $$PWD/dllimportexport.h \
    $$PWD/qqmlobjectlistmodel.h \
    $$PWD/qqmlvariantlistmodel.h
#}

DISTFILES += \
    $$PWD/mac/mac.pri
