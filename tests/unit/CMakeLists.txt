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
    # Find Qt bin directory for Windows DLL runtime dependencies
    get_target_property(QT_QMAKE_EXECUTABLE Qt6::qmake IMPORTED_LOCATION)
    if(QT_QMAKE_EXECUTABLE)
        get_filename_component(QT_BIN_DIR "${QT_QMAKE_EXECUTABLE}" DIRECTORY)
    else()
        # Fallback: try to derive from Qt6_DIR
        if(Qt6_DIR)
            get_filename_component(QT_PREFIX "${Qt6_DIR}/../../.." ABSOLUTE)
            set(QT_BIN_DIR "${QT_PREFIX}/bin")
        else()
            # Last resort: use QT_ROOT_DIR environment variable
            set(QT_BIN_DIR "$ENV{QT_ROOT_DIR}/bin")
        endif()
    endif()
    add_test(NAME test_qqmlobjectlistmodel COMMAND test_qqmlobjectlistmodel)
    if(QT_BIN_DIR AND EXISTS "${QT_BIN_DIR}")
        set_tests_properties(test_qqmlobjectlistmodel PROPERTIES
            ENVIRONMENT "PATH=$<TARGET_FILE_DIR:CPPQmlModels>\;$<SHELL_PATH:${QT_BIN_DIR}>\;$ENV{PATH}"
        )
    else()
        set_tests_properties(test_qqmlobjectlistmodel PROPERTIES
            ENVIRONMENT "PATH=$<TARGET_FILE_DIR:CPPQmlModels>\;$ENV{PATH}"
        )
    endif()
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
    if(QT_BIN_DIR AND EXISTS "${QT_BIN_DIR}")
        set_tests_properties(test_qqmlvariantlistmodel PROPERTIES
            ENVIRONMENT "PATH=$<TARGET_FILE_DIR:CPPQmlModels>\;$<SHELL_PATH:${QT_BIN_DIR}>\;$ENV{PATH}"
        )
    else()
        set_tests_properties(test_qqmlvariantlistmodel PROPERTIES
            ENVIRONMENT "PATH=$<TARGET_FILE_DIR:CPPQmlModels>\;$ENV{PATH}"
        )
    endif()
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
    if(QT_BIN_DIR AND EXISTS "${QT_BIN_DIR}")
        set_tests_properties(test_qtsupermacros PROPERTIES 
            ENVIRONMENT "PATH=$<TARGET_FILE_DIR:CPPQmlModels>\;$<SHELL_PATH:${QT_BIN_DIR}>\;$ENV{PATH}"
        )
    else()
        set_tests_properties(test_qtsupermacros PROPERTIES 
            ENVIRONMENT "PATH=$<TARGET_FILE_DIR:CPPQmlModels>\;$ENV{PATH}"
        )
    endif()
else()
    add_test(NAME test_qtsupermacros COMMAND test_qtsupermacros)
endif()

## macOS/Linux: default add_test is fine