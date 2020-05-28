mac{
    warning("Building QtQMLModel for mac")
    include(osx.pri)
    include(ios.pri)

#    INSTALLS+=target
}

DISTFILES += \
    $$PWD/osx.pri \
    $$PWD/ios.pri
