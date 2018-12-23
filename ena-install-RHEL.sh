#!/bin/bash
# Install necessary packages to compile and install source
sudo yum install gcc
sudo yum update
sudo yum install kernel-devel-$(uname -r)
pwd
cd /tmp
wget https://github.com/amzn/amzn-drivers/archive/master.zip
unzip master.zip -d /tmp/amzn-drivers
cd /tmp/amzn-drivers/kernel/linux/ena
make
insmod ena.ko
cp ena.ko to /lib/modules/$(uname -r)/
mkdir /etc/modules-load.d
cat "ena" >> /etc/modules-load.d/ena.conf
# Update module dependencies
sudo depmod
# Update initramfs to ensure new modules load at boot time
dracut -f -v

# Check systemd or udev version is greater than 197 or not
ver=`(rpm -qa | grep -e '^systemd-[0-9]\+\|^udev-[0-9]\+')`
parse=`(echo $ver | cut -d'-' -f2)`
echo $parse


# Disable predictable network interface names if it is more than 197
#sudo sed -i '/^GRUB\_CMDLINE\_LINUX/s/\"$/\ net\.ifnames\=0\"/' /etc/default/grub

# Rebuild the grub config file
#sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# Restart the instance
#reboot
