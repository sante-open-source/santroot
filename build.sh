#!/bin/bash -e
wget -q -O- https://toolchains.bootlin.com/downloads/releases/toolchains/x86-64/tarballs/x86-64--glibc--bleeding-edge-2022.08-1.tar.bz2 | tar -xjf- -C /opt
ls /opt/x86-64--glibc--bleeding-edge-2022.08-1
