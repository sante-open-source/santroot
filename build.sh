#!/bin/bash -e
wget -q -O- https://toolchains.bootlin.com/downloads/releases/toolchains/x86-64/tarballs/x86-64--glibc--bleeding-edge-2022.08-1.tar.bz2 | tar -xjf- -C /opt
# Santroot build
# Export paths
export PATH="$PATH:/opt/x86-64--glibc--bleeding-edge-2022.08-1/bin"
# Build a santroot
# 1. m4
wget -q -O- https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.xz | tar -xJf-
cd m4*
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
cd ncurses*
sed -i s/mawk// configure
mkdir build
pushd build
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
make --silent DESTDIR=/opt/santroot TIC_PATH=$(pwd)/build/progs/tic install
echo "INPUT(-lncursesw)" > /opt/santroot/usr/lib/libncurses.so
cd ..
rm -rf ncurses*
# 3. dash
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
# 4. coreutils
wget -q -O- https://ftp.gnu.org/gnu/coreutils/coreutils-9.2.tar.xz | tar -xJf-
cd coreutils-*
mkdir build
pushd build
  ../configure --prefix=/usr \
	       --libexecdir=/usr/lib \
	       --host=x86_64-buildroot-linux-gnu \
	       --build=$(../build-aux/config.guess) \
	       --silent \
	       FORCE_UNSAFE_CONFIGURE=1
  make --silent
  make --silent DESTDIR=/opt/santroot install
popd
cd ..
rm -rf coreutils*
# 5. diffutils
wget -q -O- https://ftp.gnu.org/gnu/diffutils/diffutils-3.9.tar.xz | tar -xJf-
cd diffutils*
mkdir build
pushd build
  ../configure --prefix=/usr \
	       --host=x86_64-buildroot-linux-gnu \
	       --silent
  make --silent
  make --silent DESTDIR=/opt/santroot install
popd
cd ..
rm -rf diffutils*
# 6. file
git clone https://github.com/file/file
cd file*
autoreconf -fi
mkdir build
pushd build
  ../configure --disable-bzlib \
               --disable-libseccomp \
               --disable-xzlib \
               --disable-zlib \
	       --silent
  make
popd
./configure --prefix=/usr \
	    --host=x86_64-buildroot-linux-gnu \
	    --build=$(./config.guess) \
	    --silent
make --silent FILE_COMPILE=$(pwd)/build/src/file
make --silent DESTDIR=/opt/santroot install
cd ..
rm -rf file*
# 7. findutils
wget -q -O- https://ftp.gnu.org/gnu/findutils/findutils-4.9.0.tar.xz | tar -xJf-
cd findutils*
mkdir build
pushd build
  ../configure --prefix=/usr \
	       --localstatedir=/var/lib/locate \
	       --host=x86_64-buildroot-linux-gnu \
	       --build=$(../build-aux/config.guess) \
	       --silent
  make --silent
  make --silent DESTDIR=/opt/santroot install
popd
cd ..
rm -rf findutils*
# 8. mawk
git clone https://github.com/ThomasDickey/mawk-snapshots mawk
cd mawk*
sed -ie 's|log()|log(1.0)|g' configure
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
rm -rf mawk*
# 9. mawk2
wget -q -O- https://github.com/mikebrennan000/mawk-2/raw/master/mawk-1.9.9.6.tar.gz | tar -xJf-
cd mawk*
mkdir build
pushd build
  ../configure --prefix=/usr \
               --host=x86_64-buildroot-linux-gnu \
	       --build=$(../config.guess) \
	       --silent
  make --silent
  cp mawk2 /opt/santroot/usr/bin
  cp man/mawk.1 /usr/share/man/man1/mawk2.1
popd
cd ..
rm -rf mawk*
# 10. gawk
wget -q -O- https://ftp.gnu.org/gnu/gawk/gawk-5.2.1.tar.xz | tar -xJf-
cd gawk*
mkdir build                                                                             pushd build
  ../configure --prefix=/usr \
               --host=x86_64-buildroot-linux-gnu \
               --build=$(../build-aux/config.guess) \
               --silent
  make --silent
  make --silent DESTDIR=/opt/santroot install
popd
cd ..
rm -rf gawk*
ls /opt/santroot
