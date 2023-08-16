sudo apt-get install patchelf
glibc2_25_install_path=/home/master/gcc75/lib
patchelf --set-interpreter $glibc2_25_install_path/ld-linux-armhf.so.3 --set-rpath $glibc2_25_install_path/ client-benchmark
libdatachannel_install_path=/home/master/libdatachannel
chmod +x $libdatachannel_install_path/client-benchmark
chmod +x $glibc2_25_install_path/*
LD_LIBRARY_PATH=$libdatachannel_install_path:$glibc2_25_install_path $libdatachannel_install_path/client-benchmark
