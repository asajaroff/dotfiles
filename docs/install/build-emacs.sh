#!/usr/bin/env bash

EMACS_TARBALL='https://ftp.fau.de/gnu/emacs/emacs-30.2.tar.gz'

wget -L ${EMACS_TARBALL}

tar xcvf ${EMACS_TARBALL}

cd ./emacs || exit 1

./configure --with-native-compilation=aot\
            --with-tree-sitter\
            --with-gif\
            --with-png\
            --with-jpeg\
            --with-rsvg\
            --with-imagemagick\
            --with-pgtk

make build

sudo make install
