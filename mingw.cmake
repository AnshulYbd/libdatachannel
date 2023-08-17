SET(CMAKE_SYSTEM_NAME     	Linux)
SET(CMAKE_SYSTEM_PROCESSOR 	armv7l)
SET(CMAKE_SYSTEM_VERSION 	1)
SET(CMAKE_CROSSCOMPILING 	TRUE)
#SET(BUILD_TOOL_ROOT_PATH	"${CMAKE_CURRENT_LIST_DIR}/toolchains/gcc-arm-10.3-2021.07-mingw-w64-i686-arm-none-linux-gnueabihf" )
SET(BUILD_TOOL_ROOT_PATH	"D:/toolchains/gcc-arm-10.3-2021.07-mingw-w64-i686-arm-none-linux-gnueabihf" ) #hardcoding for vscode support
SET(BUILD_GCC_PREFIX 		arm-none-linux-gnueabihf )

#SET(BUILD_TOOL_ROOT_PATH 	"D:/toolchains/gcc-linaro-7.5.0-2019.12-i686-mingw32_arm-linux-gnueabihf" )
#SET(BUILD_GCC_PREFIX 		arm-linux-gnueabihf )
SET(sysroot_target  		"${BUILD_TOOL_ROOT_PATH}/${BUILD_GCC_PREFIX}/libc" )
SET(tools           		"${BUILD_TOOL_ROOT_PATH}/bin" )
SET(CMAKE_C_COMPILER    	"${tools}/${BUILD_GCC_PREFIX}-gcc.exe" )
SET(CMAKE_CXX_COMPILER  	"${tools}/${BUILD_GCC_PREFIX}-g++.exe" )
SET(CMAKE_LIBRARY_ARCHITECTURE	 arm-linux-gnueabihf)
SET(CMAKE_SYSROOT   		"${sysroot_target}" )
SET(CMAKE_SKIP_BUILD_RPATH 	TRUE)
SET (OPENSSL_ROOT_DIR 		"${CMAKE_CURRENT_LIST_DIR}/third_party/${CMAKE_LIBRARY_ARCHITECTURE}/openssl_cmake_crossbuilt7.5")
SET(CMAKE_USE_EXTERNAL_RPATH_FOR_INSTALL TRUE)
SET(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY" )
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
