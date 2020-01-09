
# Qt super-macros

QT += core qml

INCLUDEPATH += $$PWD

HEADERS += \
    $$PWD/qqmlautopropertyhelpers.h \
    $$PWD/qqmlconstrefpropertyhelpers.h \
    $$PWD/qqmlenumclasshelper.h \
    $$PWD/qqmlhelperscommon.h \
    $$PWD/qqmllistpropertyhelper.h \
    $$PWD/qqmlptrpropertyhelpers.h \
    $$PWD/qqmlvarpropertyhelpers.h

SOURCES += \
    $$PWD/qqmlhelpers.cpp

DISTFILES += \
    $$PWD/README.md \
    $$PWD/LICENSE.md

