#!/usr/bin/env sh

cd src
echo "spin"
spin -a mutual-exclusion.pml -D$1
echo "gcc"
gcc -O2 -o pan pan.c
echo "code"
./pan -a

cd ..
