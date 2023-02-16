cmake_minimum_required(VERSION 3.22)

project(CPPQmlModels VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
#set(CMAKE_INCLUDE_CURRENT_DIR ON)

set_target_properties(PROPERTIES LINKER_LANGUAGE CXX)
include(GenerateExportHeader)
find_package(Qt6 COMPONENTS REQUIRED
    Core
    Qml
    )

qt_add_library(CPPQmlModels ${LIB_COMPILE_MODE}
#    PUBLIC
    src/qqmlmodels_global.h

    src/qqmlobjectlistmodel.h
    src/qqmlobjectlistmodel.cpp
    #I don't know how to use this.. so i coment this until future implementation
#    src/qqmlobjectsortfilterlistmodel.h
#    src/qqmlobjectsortfilterlistmodel.cpp
    src/qqmlvariantlistmodel.h
    src/qqmlvariantlistmodel.cpp

    src/QtSuperMacros/qqmlautopropertyhelpers.h
    src/QtSuperMacros/qqmlconstrefpropertyhelpers.h
    src/QtSuperMacros/qqmlenumclasshelper.h
    src/QtSuperMacros/qqmlhelpers.cpp
    src/QtSuperMacros/qqmlhelperscommon.h
    src/QtSuperMacros/qqmllistpropertyhelper.h
    src/QtSuperMacros/qqmlptrpropertyhelpers.h
    src/QtSuperMacros/qqmlvarpropertyhelpers.h
)


target_include_directories(CPPQmlModels
    PUBLIC
    src/QtSuperMacros
    src
)
#add_subdirectory(src)


target_link_libraries(CPPQmlModels PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Qml
)

set(CPPQmlModels_PUBLIC_HEADERS
    src/qqmlmodels_global.h
    src/qqmlobjectlistmodel.h
    src/qqmlvariantlistmodel.h
    src/QtSuperMacros/qqmlautopropertyhelpers.h
    src/QtSuperMacros/qqmlconstrefpropertyhelpers.h
    src/QtSuperMacros/qqmlenumclasshelper.h
    src/QtSuperMacros/qqmlhelperscommon.h
    src/QtSuperMacros/qqmllistpropertyhelper.h
    src/QtSuperMacros/qqmlptrpropertyhelpers.h
    src/QtSuperMacros/qqmlvarpropertyhelpers.h

)
set_target_properties(CPPQmlModels PROPERTIES PUBLIC_HEADER "${CPPQmlModels_PUBLIC_HEADERS}")

install(TARGETS CPPQmlModels
    EXPORT CPPQmlModelsTargets
    LIBRARY DESTINATION "lib"
    ARCHIVE DESTINATION "lib"
    RUNTIME DESTINATION "bin"
    PUBLIC_HEADER DESTINATION "include/CPPQmlModels"
    #                      COMPONENT library
)
#install(EXPORT qzxingTargets
#    FILE qzxingTargets.cmake
#    NAMESPACE QZXing::
#    DESTINATION lib/cmake/QZXing
#)

## Create a version file
#include(CMakePackageConfigHelpers)
#write_basic_package_version_file("QZXing.cmake"
#    VERSION ${PROJECT_VERSION}
#    COMPATIBILITY SameMajorVersion
#)

## Create a config file
#configure_package_config_file("${CMAKE_CURRENT_SOURCE_DIR}/QZXing.cmake.in"
#    "${CMAKE_CURRENT_BINARY_DIR}/QZXing.cmake"
#    INSTALL_DESTINATION "lib/cmake/QZXing"
#    NO_SET_AND_CHECK_MACRO
#)

## Install the config and version files
#install(FILES "${CMAKE_CURRENT_BINARY_DIR}/QZXing.cmake"
#    "${CMAKE_CURRENT_BINARY_DIR}/QZXing.cmake"
#    DESTINATION "lib/cmake/QZXing"
#)


#configure_package_config_file("${CMAKE_CURRENT_SOURCE_DIR}/QZXingConfig.cmake.in"
#    "${CMAKE_CURRENT_BINARY_DIR}/QZXingConfig.cmake"
#    INSTALL_DESTINATION "lib/cmake/QZXing"
#    NO_SET_AND_CHECK_MACRO
#)
#install(FILES "${CMAKE_CURRENT_BINARY_DIR}/QZXingConfig.cmake"
#    DESTINATION "lib/cmake/QZXing"
#)
