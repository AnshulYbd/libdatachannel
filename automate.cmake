SET(CMAKE_SYSTEM_NAME     	Linux)
SET(CMAKE_SYSTEM_PROCESSOR 	armv7l)
SET(CMAKE_SYSTEM_VERSION 	1)
SET(CMAKE_CROSSCOMPILING 	TRUE)

SET(BUILD_TOOL_ROOT_PATH 	"$ENV{GCC_PATH}" )
SET(GCC_BIN_PREFIX 		 $ENV{GCC_PREFIX})
SET(sysroot_target  	 	"${BUILD_TOOL_ROOT_PATH}/${GCC_BIN_PREFIX}/libc" )
SET(tools           	 	"${BUILD_TOOL_ROOT_PATH}/bin" )
SET(CMAKE_C_COMPILER    	"${BUILD_TOOL_ROOT_PATH}/bin/${GCC_BIN_PREFIX}-gcc.exe" )
SET(CMAKE_CXX_COMPILER  	"${BUILD_TOOL_ROOT_PATH}/bin/${GCC_BIN_PREFIX}-g++.exe" )
SET(CMAKE_LIBRARY_ARCHITECTURE 		arm-linux-gnueabihf)
SET(CMAKE_SYSROOT   		"${BUILD_TOOL_ROOT_PATH}/${GCC_BIN_PREFIX}/libc" )
SET(CMAKE_SKIP_BUILD_RPATH TRUE)

SET (OPENSSL_ROOT_DIR "${CMAKE_CURRENT_LIST_DIR}/third_party/${CMAKE_LIBRARY_ARCHITECTURE}/openssl_cmake_crossbuilt7.5")

SET(CMAKE_USE_EXTERNAL_RPATH_FOR_INSTALL 	TRUE)
SET(CMAKE_TRY_COMPILE_TARGET_TYPE 		"STATIC_LIBRARY" )
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM	NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY 	ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE 	ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE 	ONLY)