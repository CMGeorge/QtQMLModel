mac{
    warning("Building QtQMLModel for mac")
    DESTDIR=$$[QT_INSTALL_LIBS]
    CONFIG += lib_bundle
    QMAKE_FRAMEWORK_BUNDLE_NAME = $$LIB_NAME
    export(QMAKE_FRAMEWORK_BUNDLE_NAME)
    FRAMEWORK_HEADERS.files = $$HEADERS
    FRAMEWORK_HEADERS.path = Headers
    QMAKE_BUNDLE_DATA += FRAMEWORK_HEADERS

    LIB_VERSION_PATH=$${LIB_NAME}.framework/Versions/1/$$TARGET
    QMAKE_POST_LINK += install_name_tool -id @rpath/$$LIB_VERSION_PATH $$[QT_INSTALL_LIBS]/$$LIB_VERSION_PATH $$escape_expand(\\n\\t)
#    INSTALLS+=target
}
