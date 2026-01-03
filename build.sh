#!/bin/bash

set -e
set -x

cd linux

git reset
git restore .
git clean -ffxd
make clean

for patch in ../patches/*.patch; do
  git apply -v "$patch"
done
cp ../config/* arch/arm64/configs/
    
scripts/kconfig/merge_config.sh arch/arm64/configs/{debian-working.config,defconfig,qcom_laptops.config,misc.config,waydroid.config}
make -j12 bindeb-pkg