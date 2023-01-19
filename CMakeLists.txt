cmake_minimum_required(VERSION 3.22)

project(CPPQmlModels VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
#set(CMAKE_INCLUDE_CURRENT_DIR ON)

set_target_properties(PROPERTIES LINKER_LANGUAGE CXX)
include(GenerateExportHeader)
find_package(Qt6 COMPONENTS REQUIRED
    Core)

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

add_definitions(-DQQML_EXPORT)

target_include_directories(CPPQmlModels
    PUBLIC
    src/QtSuperMacros
    src
)
#add_subdirectory(src)


target_link_libraries(CPPQmlModels PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
)
