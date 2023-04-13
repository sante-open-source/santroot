#!/bin/bash -e
export PATH="$PATH:/opt/x86-64--glibc--bleeding-edge-2022.08-1/bin"

wget -q -O- https://ftp.gnu.org/gnu/binutils/binutils-2.40.tar.xz | tar -xJf-
cd binutils*
mkdir build
pushd build
  ../configure --prefix=/usr \
	       --build=$(../config.guess) \
	       --host=x86_64-buildroot-linux-gnu \
	       --enable-shared \
	       --enable-64-bit-bfd \
	       --silent
  make --silent
  make --silent DESTDIR=/opt/santroot install
popd
cd ..
rm -rf binutils*

git clone https://gcc.gnu.org/git/gcc
cd gcc*
./contrib/download_prerequisites
mkdir build
pushd build
  ../configure --build=$(../config.guess) \
	       --host=x86_64-buildroot-linux-gnu \
	       --target=x86_64-buildroot-linux-gnu \
	       LDFLAGS_FOR_TARGET=-L$PWD/x86_64-buildroot-linux-gnu/libgcc \
	       --prefix=/usr \
	       --with-build-sysroot=/opt/x86-64--glibc--bleeding-edge-2022.08-1/x86_64-buildroot-linux-gnu \
	       --enable-default-pie \
	       --enable-default-ssp \
	       --disable-multilib \
	       --disable-libatomic \
	       --disable-libgomp \
	       --disable-libquadmath \
	       --disable-libssp \
	       --disable-libvtv \
	       --enable-languages=c,c++
  make --silent
  make --silent DESTDIR=/opt/santroot install
popd
cd ..
rm -rf gcc*
