#!/bin/bash -e
export PATH="$PATH:/opt/x86-64--glibc--bleeding-edge-2022.08-1/bin"

git clone https://sourceware.org/git/binutils-gdb.git
cd binutils-gdb*
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
rm -rf binutils-gdb*
