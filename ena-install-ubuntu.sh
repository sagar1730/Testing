#!/bin/bash
sudo apt-get update && sudo apt-get upgrade -y
#you may get an error E: Failed to fetch https://sdkrepo.atlassian.com/debian/dists/stable/contrib/binary-amd64/Packages  404  Not Found
#don't worry, you can continue without harm
sudo apt-get install -y build-essential dkms
git clone https://github.com/amzn/amzn-drivers
sudo mv amzn-drivers /usr/src/amzn-drivers-1.5.1
sudo touch /usr/src/amzn-drivers-1.5.1/dkms.conf
echo 'PACKAGE_NAME="ena"
PACKAGE_VERSION="1.5.1"
CLEAN="make -C kernel/linux/ena clean"
MAKE="make -C kernel/linux/ena/ BUILD_KERNEL=${kernelver}"
BUILT_MODULE_NAME[0]="ena"
BUILT_MODULE_LOCATION="kernel/linux/ena"
DEST_MODULE_LOCATION[0]="/updates"
DEST_MODULE_NAME[0]="ena"
AUTOINSTALL="yes"' | sudo tee -a /usr/src/amzn-drivers-1.5.1/dkms.conf
sudo dkms add -m amzn-drivers -v 1.5.1
sudo dkms build -m amzn-drivers -v 1.5.1
sudo dkms install -m amzn-drivers -v 1.5.1
modinfo ena
