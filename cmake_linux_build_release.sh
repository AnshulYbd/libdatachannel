#cmake 3.26 needs libssl-100
#Edit the source list sudo nano /etc/apt/sources.list to add the following line: 
#deb http://security.ubuntu.com/ubuntu xenial-security main
# Then 
# sudo apt update 
# sudo apt install libssl1.0.0
# cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=../tc-linux.cmake ..
# 
#ln -s $root_dir/CMake-3.26-x86_64/bin/cmake /usr/local/bin/cmake
#ln -s $root_dir/CMake-3.26-x86_64/share/cmake-3.26 /usr/local/share/cmake-3.26
#https://releases.linaro.org/components/toolchain/binaries/5.4-2017.01/arm-linux-gnueabihf/gcc-linaro-5.4.1-2017.01-x86_64_arm-linux-gnueabihf.tar.xz
#a7ed6d9e1a0e4ec9e22398330a0f8fc5  gcc-linaro-5.4.1-2017.01-x86_64_arm-linux-gnueabihf.tar.xz
#

root_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export PATH=$PATH:$root_dir/BuildTools/sshpass:$root_dir/BuildTools/CMake-3.26-x86_64/bin
HOSTARCH=x86_64
# GCC_NAME_PREFIX=gcc-linaro-5.4.1-2017.01-$HOSTARCH
#GCC_NAME_PREFIX=gcc-linaro-11.3.1-2022.06-$HOSTARCH
#GCC_NAME_SUFFIX=_arm-linux-gnueabihf

GCC_NAME_PREFIX=gcc-arm-10.3-2021.07-$HOSTARCH
GCC_NAME_SUFFIX=-arm-none-linux-gnueabihf

export GCC_NAME=$GCC_NAME_PREFIX$GCC_NAME_SUFFIX
export GCC_PREFIX=arm-none-linux-gnueabihf

export GCC_PATH="$root_dir/toolchains/$GCC_NAME"
GCC_TAR_PATH="$root_dir/toolchains/$GCC_NAME.tar.xz"
GCC_TAR_MD5='a7ed6d9e1a0e4ec9e22398330a0f8fc5'
BUILDSERVER_PASS='abcd@123'
CleanExistingToolChainSetup()
{
    echo "Running clean up of existing toolchain"
    rm -rf $GCC_PATH
    rm rm -rf $GCC_PATH
}
DownloadToolChainTar()
{
    chmod +x $root_dir/BuildTools/sshpass/sshpass5
    sshpass5 -p $BUILDSERVER_PASS ssh  -o ConnectTimeout=5  -o StrictHostKeyChecking=no anshuly@192.168.1.10 exit
    if [ $? != "0" ]; then
        echo "Failed to fetch scp tar ball, Connection failed"
        echo "Downloading tar ball"
        # wget https://releases.linaro.org/components/toolchain/binaries/5.4-2017.01/arm-linux-gnueabihf/$GCC_NAME.tar.xz
		#wget https://snapshots.linaro.org/gnu-toolchain/11.3-2022.06-1/arm-linux-gnueabihf/$GCC_NAME.tar.xz
		wget --no-check-certificate https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/10.3-2021.07/binrel/$GCC_NAME.tar.xz
    else
        echo "Secure copying tar ball from anshuly@192.168.1.10"
        sshpass5 -p $BUILDSERVER_PASS scp -o StrictHostKeyChecking=no anshuly@192.168.1.10:/home/anshuly/toolchain/linaro541/$GCC_NAME.tar.xz .
    fi
}
ValidateLocalToolChain()
{
    if [ -f "$GCC_TAR_PATH" ] 
    then
        echo "ValidateLocalToolChain - tar ball exists $GCC_TAR_PATH" 
        chksum=($(md5sum $GCC_TAR_PATH))
        echo $chksum - current
        echo $GCC_TAR_MD5 - required
        if [ $chksum = $GCC_TAR_MD5 ]
        then
            #echo Good tar file
            return
        else
            echo bad tar file
        fi
    fi
    CleanExistingToolChainSetup
    DownloadToolChainTar
    echo Extraction in progress
    tar xf $GCC_TAR_PATH --checkpoint=.100
    echo $GCC_NAME toolchain deployed successfully. 
}

mkdir -p $root_dir/toolchains && cd $root_dir/toolchains
ValidateLocalToolChain

rm -rf $root_dir/cmake_linux_build_release

#fix for non executable cloned binary on linux
chmod +x $root_dir/BuildTools/CMake-3.26-x86_64/bin/cmake
cd $root_dir

git submodule update --init --recursive --depth 1
cp  .\BuildTools\libsrtp_CMakeLists.txt .\deps\libsrtp\CMakeLists.txt
cp /Y .\BuildTools\usrsctp_CMakeLists.txt .\deps\usrsctp\CMakeLists.txt


cmake -B cmake_linux_build_release -DUSE_GNUTLS=0 -DUSE_NICE=0 -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=automate.cmake
cd ./cmake_linux_build_release
cmake --build .
cd $root_dir
