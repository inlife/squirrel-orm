#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")/lib"

cat\
  $(sed -n 's/^__orm_include("\(.*\)".*/\1.nut/p' index.nut)\
  > ../output.nut
