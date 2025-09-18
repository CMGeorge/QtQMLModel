qt_add_executable(test_qqmlobjectlistmodel
    test_qqmlobjectlistmodel.cpp
)

target_link_libraries(test_qqmlobjectlistmodel PRIVATE
    CPPQmlModels
    Qt6::Test
    Qt6::Core
    Qt6::Qml
)

add_test(NAME test_qqmlobjectlistmodel COMMAND test_qqmlobjectlistmodel)

# On Windows, set PATH to include DLL directory for test execution
if(WIN32)
    set_tests_properties(test_qqmlobjectlistmodel PROPERTIES 
        ENVIRONMENT "PATH=$<TARGET_FILE_DIR:CPPQmlModels>;$ENV{PATH}"
    )
endif()

qt_add_executable(test_qqmlvariantlistmodel
    test_qqmlvariantlistmodel.cpp
)

target_link_libraries(test_qqmlvariantlistmodel PRIVATE
    CPPQmlModels
    Qt6::Test
    Qt6::Core
    Qt6::Qml
)

add_test(NAME test_qqmlvariantlistmodel COMMAND test_qqmlvariantlistmodel)

# On Windows, set PATH to include DLL directory for test execution
if(WIN32)
    set_tests_properties(test_qqmlvariantlistmodel PROPERTIES 
        ENVIRONMENT "PATH=$<TARGET_FILE_DIR:CPPQmlModels>;$ENV{PATH}"
    )
endif()

qt_add_executable(test_qtsupermacros
    test_qtsupermacros.cpp
)

target_link_libraries(test_qtsupermacros PRIVATE
    CPPQmlModels
    Qt6::Test
    Qt6::Core
    Qt6::Qml
)

add_test(NAME test_qtsupermacros COMMAND test_qtsupermacros)

# On Windows, set PATH to include DLL directory for test execution
if(WIN32)
    set_tests_properties(test_qtsupermacros PROPERTIES 
        ENVIRONMENT "PATH=$<TARGET_FILE_DIR:CPPQmlModels>;$ENV{PATH}"
    )
endif()