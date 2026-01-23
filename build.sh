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

#apply multiple config files at once
scripts/kconfig/merge_config.sh arch/arm64/configs/{debian-working.config,defconfig,qcom_laptops.config,misc.config,waydroid.config,x1e-vivobook.config}

#remove the trailing + in the version number
sed -i 's/${scm_version}//' scripts/setlocalversion

make -j12 bindeb-pkg

cd ..
mkdir -p out
mv ./*.deb ./*changes ./*buildinfo out/