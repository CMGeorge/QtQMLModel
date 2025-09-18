qt_add_executable(test_qqmlobjectlistmodel
    test_qqmlobjectlistmodel.cpp
)

target_link_libraries(test_qqmlobjectlistmodel PRIVATE
    CPPQmlModels
    Qt6::Test
    Qt6::Core
    Qt6::Qml
)

if(WIN32)
    # Compute Qt bin dir from Qt6_DIR (points to .../lib/cmake/Qt6)
    if(DEFINED ENV{Qt6_DIR})
        get_filename_component(Qt6_CMAKE_DIR "$ENV{Qt6_DIR}" ABSOLUTE)
        get_filename_component(Qt6_PREFIX "${Qt6_CMAKE_DIR}/../.." ABSOLUTE)
        set(QT_BIN_DIR "${Qt6_PREFIX}/bin")
    endif()
    add_test(NAME test_qqmlobjectlistmodel COMMAND test_qqmlobjectlistmodel)
    set_tests_properties(test_qqmlobjectlistmodel PROPERTIES
        ENVIRONMENT "PATH=$<TARGET_FILE_DIR:CPPQmlModels>\;$<SHELL_PATH:${QT_BIN_DIR}>\;$ENV{PATH}"
    )
else()
    add_test(NAME test_qqmlobjectlistmodel COMMAND test_qqmlobjectlistmodel)
endif()

## macOS/Linux: default add_test is fine

qt_add_executable(test_qqmlvariantlistmodel
    test_qqmlvariantlistmodel.cpp
)

target_link_libraries(test_qqmlvariantlistmodel PRIVATE
    CPPQmlModels
    Qt6::Test
    Qt6::Core
    Qt6::Qml
)

if(WIN32)
    add_test(NAME test_qqmlvariantlistmodel COMMAND test_qqmlvariantlistmodel)
    set_tests_properties(test_qqmlvariantlistmodel PROPERTIES
        ENVIRONMENT "PATH=$<TARGET_FILE_DIR:CPPQmlModels>\;$<SHELL_PATH:${QT_BIN_DIR}>\;$ENV{PATH}"
    )
else()
    add_test(NAME test_qqmlvariantlistmodel COMMAND test_qqmlvariantlistmodel)
endif()

## macOS/Linux: default add_test is fine

qt_add_executable(test_qtsupermacros
    test_qtsupermacros.cpp
)

target_link_libraries(test_qtsupermacros PRIVATE
    CPPQmlModels
    Qt6::Test
    Qt6::Core
    Qt6::Qml
)

if(WIN32)
    add_test(NAME test_qtsupermacros COMMAND test_qtsupermacros)
    set_tests_properties(test_qtsupermacros PROPERTIES 
        ENVIRONMENT "PATH=$<TARGET_FILE_DIR:CPPQmlModels>\;$<SHELL_PATH:${QT_BIN_DIR}>\;$ENV{PATH}"
    )
else()
    add_test(NAME test_qtsupermacros COMMAND test_qtsupermacros)
endif()

## macOS/Linux: default add_test is fine