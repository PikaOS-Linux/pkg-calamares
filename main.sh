#! /bin/bash
set -e
DEBIAN_FRONTEND=noninteractive

# Clone Upstream
#git clone https://github.com/calamares/calamares -b v3.3.0-alpha2
#cp -rvf ./calamares2 ./calamares
cd ./calamares
for i in ../patches/*; do patch -Np1 -i $i ;done

# Get build deps
apt-get build-dep ./ -y || true

# Build package
LOGNAME=root dh_make --createorig -y -l -p calamares_3.3.0-alpha2 || true
dpkg-buildpackage --no-sign

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
