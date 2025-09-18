add_subdirectory(unit)

if(WIN32)
	# Derive Qt bin dir from Qt6_DIR, fallback to Qt Core location if needed
	if(DEFINED ENV{Qt6_DIR})
		get_filename_component(Qt6_CMAKE_DIR "$ENV{Qt6_DIR}" ABSOLUTE)
		get_filename_component(Qt6_PREFIX "${Qt6_CMAKE_DIR}/../.." ABSOLUTE)
		set(QT_BIN_DIR "${Qt6_PREFIX}/bin")
	endif()
	# Compose a PATH that includes our DLL output and Qt's bin
	set(TEST_ENV_PATH "$<TARGET_FILE_DIR:CPPQmlModels>\;$<SHELL_PATH:${QT_BIN_DIR}>\;$ENV{PATH}")
	set_property(GLOBAL PROPERTY CTEST_ENVIRONMENT "PATH=${TEST_ENV_PATH}")
endif()