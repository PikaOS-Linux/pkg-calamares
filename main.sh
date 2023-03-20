#! /bin/bash
set -e
DEBIAN_FRONTEND=noninteractive

# Add dependent repositories
wget -q -O - https://ppa.pika-os.com/key.gpg | sudo apt-key add -
add-apt-repository https://ppa.pika-os.com
add-apt-repository ppa:pikaos/pika
add-apt-repository ppa:kubuntu-ppa/backports

# Clone Upstream
#git clone https://github.com/calamares/calamares -b v3.3.0-alpha2
#cp -rvf ./calamares2 ./calamares
cd ./calamares
for i in ../patches/*; do patch -Np1 -i $i ;done

# Get build deps
ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata || true
apt-get build-dep ./ -y || true

# Build package
LOGNAME=root dh_make --createorig -y -l -p calamares_3.3.0-alpha2 || true
dpkg-buildpackage --no-sign

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
