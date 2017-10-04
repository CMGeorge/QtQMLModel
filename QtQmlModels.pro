
TARGET = $$qtLibraryTarget(QQmlModels)

TEMPLATE = lib

TEMPLATE = lib
CONFIG  *= qt warn_on
CONFIG  *= relative_qt_rpath
CONFIG  *= debug
CONFIG  *= release
CONFIG  *= build_all
PREFIX=$$[QT_INSTALL_PREFIX]

DEFINES += LIB_BUILD

include ($$PWD/QtQmlModels.pri)
unix:!symbian {
    headers.path=$$PREFIX/include/QQmlModels
    headers.files=$$HEADERS
    target.path=$$PREFIX/lib
    INSTALLS += headers target

        OBJECTS_DIR=.obj
        MOC_DIR=.moc

}

win32 {
    headers.path=$$PREFIX/include/QQmlModels
    headers.files=$$HEADERS
    target.path=$$PREFIX/lib
    INSTALLS += headers target
    # workaround for qdatetime.h macro bug
    DEFINES += NOMINMAX
}
CONFIG *= install_ok  # Do not cargo-cult this!
CONFIG *= install
