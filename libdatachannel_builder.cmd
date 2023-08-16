echo off
set root_dir=%cd%

set GCC_PATH=%root_dir%\toolchains\%GCC_NAME%
set TARGET_ARCH=arm-linux-gnueabihf
set GCC_NAME=gcc-linaro-7.5.0-2019.12-i686-mingw32_%TARGET_ARCH%
@REM if exist "%root_dir%\toolchains\%GCC_NAME%" (
@REM     echo "tool chain path gcc present"
@REM ) else (
@REM     echo "Downloading tar ball now"
@REM mkdir %root_dir%\toolchains
@REM cd %root_dir%\toolchains
@REM     IF "%TARGET_ARCH%"=="aarch64-linux-gnu" (
@REM         wget https://releases.linaro.org/components/toolchain/binaries/latest-7/aarch64-linux-gnu/gcc-linaro-7.5.0-2019.12-i686-mingw32_aarch64-linux-gnu.tar.xz
@REM     )
@REM     IF "%TARGET_ARCH%"=="arm-linux-gnueabihf" (
@REM         wget https://releases.linaro.org/components/toolchain/binaries/latest-7/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-i686-mingw32_arm-linux-gnueabihf.tar.xz
@REM     )
	
@REM 	set EXRACT_BIN="7z.exe"
@REM 	path|find "%root_dir%\BuildTools\7z-win"    >nul || set path=%path%;%root_dir%\BuildTools\7z-win
@REM 	%EXRACT_BIN% x %GCC_NAME%.tar.xz -so | %EXRACT_BIN% x -si -y -ttar
@REM )

@rem workaround 
copy .\BuildTools\libsrtp_CMakeLists.txt .\deps\libsrtp\CMakeLists.txt
cmake -B build -DUSE_GNUTLS=0 -DUSE_NICE=0 -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=..\automate.cmake
cd ./build
cmake --build .
