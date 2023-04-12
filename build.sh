#!/bin/bash -e
wget -q -O- https://toolchains.bootlin.com/downloads/releases/toolchains/x86-64/tarballs/x86-64--glibc--bleeding-edge-2022.08-1.tar.bz2 | tar -xjf- -C /opt
# Santroot build
# Export paths
export PATH="$PATH:/opt/x86-64--glibc--bleeding-edge-2022.08-1/bin"
# Build a santroot
# 1. m4
wget -q -O- https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.xz | tar -xJf-
cd m4-1.4.19
mkdir build
pushd build
  ../configure --prefix=/usr \
	       --host=x86_64-buildroot-linux-gnu \
	       --build=$(../build-aux/config.guess) \
	       --silent
  make --silent
  make --silent DESTDIR=/opt/santroot install
popd
cd ..
rm -rf m4*
# 2. ncurses
git clone https://github.com/ThomasDickey/ncurses-snapshots ncurses
cd ncurses
sed -i s/mawk// configure
mkdir build-tic
pushd build-tic
  ../configure --silent
  make --silent -C include
  make --silent -C progs tic
popd
./configure --prefix=/usr \
	    --host=x86_64-buildroot-linux-gnu \
	    --build=$(./config.guess) \
	    --mandir=/usr/share/man \
	    --with-manpage-format=normal \
	    --with-shared \
	    --without-normal \
	    --with-cxx-shared \
	    --without-debug \
	    --without-ada \
	    --disable-stripping \
	    --enable-widec \
	    --silent
make --silent
make --silent DESTDIR=/opt/santroot TIC_PATH=$(pwd)/build-tic/progs/tic install
echo "INPUT(-lncursesw)" > /opt/santroot/usr/lib/libncurses.so
rm -rf ncurses*
# 3. libedit
git clone https://salsa.debian.org/debian/libedit.git
cd libedit
mkdir build
pushd build
  ../configure --prefix=/usr \
	       --host=x86_64-buildroot-linux-gnu \
	       --build=$(../config.guess) \
	       --silent
  make --silent
  make --silent DESTDIR=/opt/santroot install
popd
cd ..
rm -rf libedit*
# 4. dash
git clone https://salsa.debian.org/debian/dash.git
cd dash
mkdir build
pushd build
  ../configure --prefix=/usr \
               --bindir=/usr/bin \
               --mandir=/usr/share/man \
	       --host=x86_64-buildroot-linux-gnu \
	       --silent
  make --silent
  make --silent DESTDIR=/opt/santroot install
popd
cd ..
rm -rf dash*
# 5. coreutils
git clone git://git.savannah.gnu.org/coreutils.git
cd coreutils
./bootstrap
mkdir build
pushd build
  ../configure --prefix=/usr \
	       --libexecdir=/usr/lib \
	       --host=$LFS_TGT \
	       --build=$(../build-aux/config.guess)
  make --silent
  make --silent DESTDIR=/opt/santroot install
popd
cd ..
rm -rf coreutils*
# 6. diffutils

ls /opt/santroot
