LIB_NAME=QQmlModels
TARGET = $$LIB_NAME
QT += core \
        qml
CONFIG-=create_cmake
DEFINES += QQML_EXPORT
include ($$PWD/qqmlmodels.pri)
HEADERS += $$MODULE_HEADERS
load(qt_module)
