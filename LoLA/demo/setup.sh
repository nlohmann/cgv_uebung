#!/bin/bash

LOLA=lola-1.01

tar xfz $LOLA.tar.gz
cd $LOLA ; ./configure ; cd ..

for CONFIG in configs/userconfig.*
do
    NAME=$(echo $CONFIG | sed 's|configs/userconfig.H.||')
    echo "Building $NAME..."

    cp $CONFIG $LOLA/src/userconfig.H
    make -C $LOLA 2> /dev/null > /dev/null
    cp $LOLA/src/lola $NAME
done

rm -fr $LOLA
