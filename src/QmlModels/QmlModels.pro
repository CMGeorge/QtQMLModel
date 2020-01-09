TEMPLATE = lib
#MODULE = QmlModels
#TARGET=QmlModels
OUT_PWD = $$PWD
#DESTDIR = $$[QT_INSTALL_LIBS]
#QT += core \
#        qml
DEFINES += QQML_EXPORT
include ($$PWD/qqmlmodels.pri)
#HEADERS += $$MODULE_HEADERS
#CMAKE_MODULE_TESTS = '-'
#VERSION = 1.0.0
#load(qt_build_config)
load(qt_module)
