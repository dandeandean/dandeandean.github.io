#!/usr/bin/env bash
if [ $(ls $(git rev-parse --show-toplevel)/home-page/themes/terminus) ] ; then
  echo "Submodule already there or themes/terminus is populated"
else
  echo "installing submodule"
  git submodule update --init
fi

