LIB_NAME=QQmlModels
TARGET = $$LIB_NAME
DEFINES += QQML_LIB_BUILD
include ($$PWD/QtQmlModels.pri)
#HEADERS += $$MODULE_HEADERS
load(qt_module)
