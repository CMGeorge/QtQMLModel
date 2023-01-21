cmake_minimum_required(VERSION 3.22)

set(PROJECT_NAME CPPQmlModels)
project(${PROJECT_NAME} VERSION 1.0 LANGUAGES CXX)


set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD_REQUIRED ON)


#set(CMAKE_INCLUDE_CURRENT_DIR ON)
include_directories(AFTER src/QtSuperMacros/)

set_target_properties(PROPERTIES LINKER_LANGUAGE CXX)
include(GenerateExportHeader)
find_package(Qt6 COMPONENTS REQUIRED
    Core
    Qml
)

set(PROJECT_PUBLIC_HEADERS
    src/qqmlmodels_global.h

    src/qqmlobjectlistmodel.h
    src/QtSuperMacros/qqmlautopropertyhelpers.h
    src/QtSuperMacros/qqmlconstrefpropertyhelpers.h
    src/QtSuperMacros/qqmlenumclasshelper.h
    src/QtSuperMacros/qqmlhelpers.cpp
    src/QtSuperMacros/qqmlhelperscommon.h
    src/QtSuperMacros/qqmllistpropertyhelper.h
    src/QtSuperMacros/qqmlptrpropertyhelpers.h
    src/QtSuperMacros/qqmlvarpropertyhelpers.h
    src/QtSuperMacros/qqmlhelperscommon.h
    src/qqmlobjectlistmodelbase.h

)
qt_add_library(${PROJECT_NAME} ${LIB_COMPILE_MODE}
    #    PUBLIC


#    src/qqmlobjectlistmodel.cpp
    #I don't know how to use this.. so i coment this until future implementation
    #    src/qqmlobjectsortfilterlistmodel.h
    #    src/qqmlobjectsortfilterlistmodel.cpp
    src/qqmlvariantlistmodel.cpp
    src/qqmlobjectlistmodelbase.cpp

    ${PROJECT_PUBLIC_HEADERS}


)
target_compile_definitions(${PROJECT_NAME} PRIVATE -DQQML_EXPORT)
set_target_properties(${PROJECT_NAME} PROPERTIES
    PUBLIC_HEADER
    "${PROJECT_PUBLIC_HEADERS};src/qqmlvariantlistmodel.h"


)


target_include_directories(${PROJECT_NAME}
    PUBLIC
    src/QtSuperMacros
    src
)
#add_subdirectory(src)


target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Qml

)

message("CMAKE_INSTALL_INCLUDEDIR  = ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}")
install(
    TARGETS ${PROJECT_NAME}
    LIBRARY
    PUBLIC_HEADER
    DESTINATION  ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}
)


add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/tests/auto/DLLExportImportTest)
