ios{
    warning("Building for iOS")
    headers.path=$$PREFIX/include/$$LIB_NAME
    headers.files=$$HEADERS
    target.path=$$PREFIX/lib
    INSTALLS += headers target
        OBJECTS_DIR=.obj
        MOC_DIR=.moc
}
