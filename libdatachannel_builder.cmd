echo off
set root_dir=%cd%

set GCC_PATH=%root_dir%\toolchains\%GCC_NAME%
set TARGET_ARCH=arm-linux-gnueabihf
set GCC_NAME=gcc-linaro-7.5.0-2019.12-i686-mingw32_%TARGET_ARCH%
if exist "%GCC_PATH%" (
    echo "tool chain path gcc present"
) else (
    echo "Downloading tar ball now"
mkdir %root_dir%\toolchains
cd %root_dir%\toolchains
    IF "%TARGET_ARCH%"=="aarch64-linux-gnu" (
        wget https://releases.linaro.org/components/toolchain/binaries/latest-7/aarch64-linux-gnu/gcc-linaro-7.5.0-2019.12-i686-mingw32_aarch64-linux-gnu.tar.xz
    )
    IF "%TARGET_ARCH%"=="arm-linux-gnueabihf" (
        wget https://releases.linaro.org/components/toolchain/binaries/latest-7/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-i686-mingw32_arm-linux-gnueabihf.tar.xz
    )
	set 7zbin="%root_dir%\BuildTools\7z-win\7z.exe"
	%7zbin% x %GCC_NAME%.tar.xz -so | %7zbin% x -si -y -ttar
)

rm -rf ./build
rm -rf ./deps
git submodule update --init --recursive --depth 1
copy /Y .\BuildTools\libsrtp_CMakeLists.txt .\deps\libsrtp\CMakeLists.txt
copy /Y .\BuildTools\usrsctp_CMakeLists.txt .\deps\usrsctp\CMakeLists.txt

cmake -B build -DUSE_GNUTLS=0 -DUSE_NICE=0 -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=automate.cmake
cd ./build
cmake --build .
cd ..
