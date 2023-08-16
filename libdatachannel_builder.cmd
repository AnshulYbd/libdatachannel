echo off
set root_dir=%cd%

path|find "%root_dir%\BuildTools\7z-win"    >nul || set path=%path%;%root_dir%\BuildTools\7z-win
path|find "%root_dir%\BuildTools\cmake-3.24-win\bin"    >nul || set path=%path%;%root_dir%\BuildTools\cmake-3.24-win\bin

set GCC_PATH=%root_dir%\toolchains\%GCC_NAME%
set TARGET_ARCH=arm-linux-gnueabihf
set GCC_NAME=gcc-linaro-7.5.0-2019.12-i686-mingw32_%TARGET_ARCH%
if exist "%root_dir%\toolchains\%GCC_NAME%" (
    echo "tool chain path gcc present"
) else (
	mkdir %root_dir%\toolchains
	cd %root_dir%\toolchains
    echo "Downloading tar ball now"
    IF "%TARGET_ARCH%"=="aarch64-linux-gnu" (
        wget https://releases.linaro.org/components/toolchain/binaries/latest-7/aarch64-linux-gnu/gcc-linaro-7.5.0-2019.12-i686-mingw32_aarch64-linux-gnu.tar.xz
    )
    IF "%TARGET_ARCH%"=="arm-linux-gnueabihf" (
        wget https://releases.linaro.org/components/toolchain/binaries/latest-7/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-i686-mingw32_arm-linux-gnueabihf.tar.xz
    )

	set EXRACT_BIN="7z.exe"
	%EXRACT_BIN% x %GCC_NAME%.tar.xz -so | %EXRACT_BIN% x -si -y -ttar
)
git submodule update --init --recursive --depth 1

cmake -B build -DUSE_GNUTLS=0 -DUSE_NICE=0 -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=..\automate.cmake
cd ./build
cmake --build .
cd %root_dir%
