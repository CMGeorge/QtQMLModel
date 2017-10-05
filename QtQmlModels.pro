LIB_NAME=QQmlModels
TARGET = $$qtLibraryTarget($$LIB_NAME)

TEMPLATE = lib

TEMPLATE = lib
CONFIG  *= qt warn_on
CONFIG  *= relative_qt_rpath
!android{
    CONFIG *= debug_and_release
    CONFIG *= build_all
}else{
    CONFIG -= debug
    CONFIG *=release
}
PREFIX=$$[QT_INSTALL_PREFIX]
target.path=$$PREFIX
DEFINES += LIB_BUILD

include ($$PWD/QtQmlModels.pri)
unix:!mac {
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
include(mac/mac.pri)
CONFIG *= install_ok  # Do not cargo-cult this!
CONFIG *= install
