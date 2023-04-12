#!/bin/bash -e
wget -q -O- https://toolchains.bootlin.com/downloads/releases/toolchains/x86-64/tarballs/x86-64--glibc--bleeding-edge-2022.08-1.tar.bz2 | tar -xjf- -C /opt
export PATH="$PATH:/opt/x86-64--glibc--bleeding-edge-2022.08-1/bin"
git clone git://git.sv.gnu.org/m4.git -b branch-2.0
cd m4
./bootstrap
mkdir build
pushd build
  ../configure --prefix=/usr \
	       --host=x86_64-buildroot-linux-gnu \
	       --build=$(../build-aux/config.guess)
  make
  make DESTDIR=/opt/santroot
popd
