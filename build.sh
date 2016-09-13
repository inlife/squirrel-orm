#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")"

cat\
  $(sed -n 's/^__orm_include("\(.*\)".*/lib\/\1.nut/p' index.nut)\
  > dst/index.nut
