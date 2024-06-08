#!/bin/bash

. ./modules.sh

mkdir -p build
cd build
cmake ..
make
