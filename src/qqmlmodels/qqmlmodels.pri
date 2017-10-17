#!CONFIG(QT_QML_MODELS){
    # Qt QML Models
#    CONFIG*=QT_QML_MODELS


    INCLUDEPATH += $$PWD

    SOURCES += \
        $$PWD/qqmlobjectlistmodel.cpp \
        $$PWD/qqmlvariantlistmodel.cpp \
		$$PWD/qqmlobjectsortfilterlistmodel.cpp

    include($$PWD/qtsupermacros/qtsupermacros.pri)

    MODULE_HEADERS += \
            $$PWD/qqmlmodels_global.h \
            $$PWD/qqmlobjectlistmodel.h \
            $$PWD/qqmlvariantlistmodel.h
#}

DISTFILES += \
    $$PWD/mac/mac.pri

HEADERS += \
    $$PWD/qqmlobjectsortfilterlistmodel.h
