cmake_minimum_required(VERSION 3.22)

project(CPPQmlModels VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Enable testing
option(BUILD_TESTING "Build tests" ON)
if(BUILD_TESTING)
    enable_testing()
endif()

include(GenerateExportHeader)
find_package(Qt6 COMPONENTS REQUIRED
    Core
    Qml
    Test
)

# Use STATIC for iOS, SHARED for other platforms
if(CMAKE_SYSTEM_NAME STREQUAL "iOS")
    set(LIBRARY_TYPE STATIC)
else()
    set(LIBRARY_TYPE SHARED)
endif()

qt_add_library(CPPQmlModels ${LIBRARY_TYPE}
    src/qqmlmodels_global.h

    src/qqmlobjectlistmodel.h
    src/qqmlobjectlistmodel.cpp
    src/qqmlvariantlistmodel.h
    src/qqmlvariantlistmodel.cpp

    src/testobject.h
    src/testobject.cpp

    src/QtSuperMacros/qqmlautopropertyhelpers.h
    src/QtSuperMacros/qqmlconstrefpropertyhelpers.h
    src/QtSuperMacros/qqmlenumclasshelper.h
    src/QtSuperMacros/qqmlhelpers.cpp
    src/QtSuperMacros/qqmlhelperscommon.h
    src/QtSuperMacros/qqmllistpropertyhelper.h
    src/QtSuperMacros/qqmlptrpropertyhelpers.h
    src/QtSuperMacros/qqmlvarpropertyhelpers.h
)

# Define that we are building the library (for export macros)
add_definitions(-DQQML_EXPORT)

target_include_directories(CPPQmlModels
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src/QtSuperMacros>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/src>
        $<INSTALL_INTERFACE:include>
    PRIVATE
        src
)

target_link_libraries(CPPQmlModels PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Qml
)

# Generate export header for Windows DLL symbols
generate_export_header(CPPQmlModels
    BASE_NAME CPPQmlModels
    EXPORT_FILE_NAME src/cppqmlmodels_export.h
)

# Set library properties
set_target_properties(CPPQmlModels PROPERTIES
    VERSION ${PROJECT_VERSION}
    SOVERSION ${PROJECT_VERSION_MAJOR}
    EXPORT_NAME CPPQmlModels
)

# On Windows, copy DLL to test directory for runtime access
if(WIN32)
    # Copy DLL to build directory where tests run
    add_custom_command(TARGET CPPQmlModels POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory $<TARGET_FILE_DIR:CPPQmlModels>/../tests/unit/$<CONFIG>/
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        $<TARGET_FILE:CPPQmlModels>
        $<TARGET_FILE_DIR:CPPQmlModels>/../tests/unit/$<CONFIG>/
        COMMENT "Copying CPPQmlModels DLL to test directory"
    )
    # Ensure dll is next to the target and path is predictable
    set_target_properties(CPPQmlModels PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/$<CONFIG>
        RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/bin/Debug
        RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/bin/Release
    )
endif()

# Install targets
install(TARGETS CPPQmlModels
    EXPORT CPPQmlModelsTargets
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
)

install(DIRECTORY src/
    DESTINATION include/CPPQmlModels
    FILES_MATCHING PATTERN "*.h"
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/src/cppqmlmodels_export.h
    DESTINATION include/CPPQmlModels
)

# Export configuration
install(EXPORT CPPQmlModelsTargets
    FILE CPPQmlModelsTargets.cmake
    NAMESPACE CPPQmlModels::
    DESTINATION lib/cmake/CPPQmlModels
)

# Create config file
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    CPPQmlModelsConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

configure_package_config_file(
    cmake/CPPQmlModelsConfig.cmake.in
    CPPQmlModelsConfig.cmake
    INSTALL_DESTINATION lib/cmake/CPPQmlModels
)

install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/CPPQmlModelsConfig.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/CPPQmlModelsConfigVersion.cmake
    DESTINATION lib/cmake/CPPQmlModels
)

# Add tests
if(BUILD_TESTING)
    add_subdirectory(tests)
endif()

# CPack configuration
set(CPACK_PACKAGE_NAME "CPPQmlModels")
set(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Qt QML Models Library")
set(CPACK_PACKAGE_VENDOR "George Calugar")
set(CPACK_PACKAGE_CONTACT "george@wesell.ro")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE.md")
set(CPACK_RESOURCE_FILE_README "${CMAKE_CURRENT_SOURCE_DIR}/README.md")

include(CPack)
