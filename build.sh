#!/bin/bash -e
wget -q -O- https://toolchains.bootlin.com/downloads/releases/toolchains/x86-64/tarballs/x86-64--glibc--bleeding-edge-2022.08-1.tar.bz2 | tar -xjf- -C /opt
export PATH="$PATH:/opt/x86-64--glibc--bleeding-edge-2022.08-1/bin"
wget -q -O- https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.xz | tar -xJf-
cd m4-1.4.19
mkdir build
pushd build
  ../configure --prefix=/usr \
	       --host=x86_64-buildroot-linux-gnu \
	       --build=$(../build-aux/config.guess)
  make
  make DESTDIR=/opt/santroot
popd
cd ..
