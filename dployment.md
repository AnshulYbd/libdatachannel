sudo apt-get install patchelf</br>
glibc2_25_install_path=/home/master/gcc75/lib</br>
patchelf --set-interpreter $glibc2_25_install_path/ld-linux-armhf.so.3 --set-rpath $glibc2_25_install_path/ client-benchmark</br>
libdatachannel_install_path=/home/master/libdatachannel</br>
chmod +x $libdatachannel_install_path/client-benchmark</br>
chmod +x $glibc2_25_install_path/*</br>
LD_LIBRARY_PATH=$libdatachannel_install_path:$glibc2_25_install_path $libdatachannel_install_path/client-benchmark</br>
