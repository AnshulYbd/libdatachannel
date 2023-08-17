cmake_minimum_required(VERSION 3.7)
if(POLICY CMP0079)
	cmake_policy(SET CMP0079 NEW)
endif()

set(STREAMER_SOURCES
	main.cpp
	dispatchqueue.cpp
	dispatchqueue.hpp
	h264fileparser.cpp
	h264fileparser.hpp
	helpers.cpp
	helpers.hpp
	opusfileparser.cpp
	opusfileparser.hpp
	fileparser.cpp
	fileparser.hpp
	stream.cpp
	stream.hpp
	ArgParser.cpp
	ArgParser.hpp
)

set(STREAMER_UWP_RESOURCES
	uwp/Logo.png
	uwp/package.appxManifest
	uwp/SmallLogo.png
	uwp/SmallLogo44x44.png
	uwp/SplashScreen.png
	uwp/StoreLogo.png
	uwp/Windows_TemporaryKey.pfx
)

if(CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
	add_executable( ndi-streamer ${STREAMER_SOURCES} ${STREAMER_UWP_RESOURCES})
else()
	add_executable(ndi-streamer ${STREAMER_SOURCES})
endif()

set_target_properties(ndi-streamer PROPERTIES
	CXX_STANDARD 17
	OUTPUT_NAME ndi-streamer)

# set_target_properties(ndi-streamer PROPERTIES
# 	XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER com.github.paullouisageneau.libdatachannel.examples.streamer)

find_package(Threads REQUIRED)
#SHARED libraries
SET(3RD_PARTY           ${BD_THIRD_PARTY})
target_include_directories(ndi-streamer PRIVATE ${3RD_PARTY}/include/ndi )
SET(LIBS_3RD_PARTY_AVAHI_PATH      ${3RD_PARTY}/arm-linux-gnueabihf/Avahi)
add_library(libdbus1 STATIC IMPORTED)
set_property(TARGET libdbus1 PROPERTY IMPORTED_LOCATION ${LIBS_3RD_PARTY_AVAHI_PATH}/libdbus-1.a)
add_library(libdbus SHARED IMPORTED)
set_property(TARGET libdbus PROPERTY IMPORTED_LOCATION ${LIBS_3RD_PARTY_AVAHI_PATH}/libdbus-1.so.3.14.6)
add_library(libavahi-client SHARED IMPORTED)
set_target_properties( libavahi-client PROPERTIES IMPORTED_LOCATION ${LIBS_3RD_PARTY_AVAHI_PATH}/libavahi-client.so.3.2.9)
add_library(libavahi-common SHARED IMPORTED)
set_target_properties( libavahi-common PROPERTIES IMPORTED_LOCATION ${LIBS_3RD_PARTY_AVAHI_PATH}/libavahi-common.so.3.5.3)
add_library(libselinux SHARED IMPORTED)
set_property(TARGET libselinux PROPERTY IMPORTED_LOCATION ${LIBS_3RD_PARTY_AVAHI_PATH}/libselinux.so.1 )
add_library(libpcre SHARED IMPORTED)
set_property(TARGET libpcre PROPERTY IMPORTED_LOCATION ${LIBS_3RD_PARTY_AVAHI_PATH}/libpcre.so.3.13.2 )
add_library(libgpg-error SHARED IMPORTED)
set_property(TARGET libgpg-error PROPERTY IMPORTED_LOCATION ${LIBS_3RD_PARTY_AVAHI_PATH}/libgpg-error.so.0.17.0)
add_library(liblzma SHARED IMPORTED)
set_property(TARGET liblzma PROPERTY IMPORTED_LOCATION ${LIBS_3RD_PARTY_AVAHI_PATH}/liblzma.so.5.0.0)
add_library(libgcrypt SHARED IMPORTED)
set_property(TARGET libgcrypt PROPERTY IMPORTED_LOCATION ${LIBS_3RD_PARTY_AVAHI_PATH}/libgcrypt.so.20.0.5)
add_library(libsystemd SHARED IMPORTED)
set_property(TARGET libsystemd PROPERTY IMPORTED_LOCATION ${LIBS_3RD_PARTY_AVAHI_PATH}/libsystemd.so.0.14)
add_library(libglib SHARED IMPORTED)
set_property(TARGET libglib PROPERTY IMPORTED_LOCATION ${LIBS_3RD_PARTY_AVAHI_PATH}/libglib-2.0.so.0.4800.2)
#supplied libraries
add_library(libndi STATIC IMPORTED)
set_property(TARGET libndi PROPERTY IMPORTED_LOCATION ${3RD_PARTY}/arm-linux-gnueabihf/libndi-armv7l.so.5)

target_link_libraries(ndi-streamer ${WINLIBS} 
	LibDataChannel::LibDataChannel 
	Threads::Threads 
	nlohmann_json::nlohmann_json
	libdbus1
	libdbus
	libselinux
	libpcre
	libgpg-error
	liblzma
	libgcrypt
	libsystemd
	libavahi-common
	libavahi-client
	libndi 
)


if(MSVC)
	add_custom_command(TARGET ndi-streamer POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E copy_if_different
		"$<TARGET_FILE_DIR:datachannel>/datachannel.dll"
		$<TARGET_FILE_DIR:ndi-streamer>
	)
endif()
