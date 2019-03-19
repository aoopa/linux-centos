#!/bin/bash
# Aoo Basic installation wrapper # Version 1.0.0.5
# Script Developed by Apivat Pattana-Anurak
# SysAdmin & Programmer Form #Bangkok #Thailand 
# curl -O https://raw.githubusercontent.com/aoopa/linux-centos/master/aoo.sh
# sh aoo.sh

################## Step1 basic install & update ####################
# install
yum install screen -y
yum install perl -y
yum install net-tools -y
yum install wget -y
yum install whois -y
yum install npm -y
yum install open-vm-tools -y
yum install epel-release -y

# update os
yum -y update

################## Step2 Create Aoo Account SSH ####################
# install sudo
yum install sudo -y
echo -e '\e[1;36mCreate Special User "aoo".....................................................................OK\e[0m';
useradd -p paHW.7qDiHJCM aoo
usermod -G wheel aoo
mkdir -p /home/aoo/.ssh
chmod 700 /home/aoo /home/aoo/.ssh
curl -o /home/aoo/.ssh/authorized_keys https://raw.githubusercontent.com/aoopa/linux-centos/master/authorized_keys
chmod 600 /home/aoo/.ssh/authorized_keys
chown aoo.aoo -R /home/aoo /home/aoo/.ssh

### AllowUsers Aoo to Superuser ###
echo -e '\e[1;36mConfig + Securing SSHD.........................................................................OK\e[0m';
echo 'AllowUsers aoo' >> /etc/ssh/sshd_config
echo 'AllowUsers root' >> /etc/ssh/sshd_config
sed -i 's/# %wheel\tALL=(ALL)\tNOPASSWD: ALL/%wheel\tALL=(ALL)\tNOPASSWD: ALL/' /etc/sudoers

# Create Perl encripted Password by Aoo : 
# https://raw.githubusercontent.com/aoopa/linux-centos/master/Create%20Perl%20encripted%20Password%20by%20Aoo

################## Step3 Install Monitor Process ####################
yum install htop -y
yum install atop -y
yum install iftop -y
yum install nmon -y

################## Step4 Install Alert Login ####################
yum install mailx -y
curl -O https://raw.githubusercontent.com/aoopa/linux-centos/master/.bashrc

rm -rf mod_evasive* csf* aoo.sh xcache*
history -c

####################### End Script ##########################
echo "************************************************************"
echo "*                      Hello : "$USER"                        *"
echo "*                 PLEASE REBOOT SERVER NOW                 *"
echo "*      Current date : $(date)         *"
echo "*                 Hostname   @ $(hostname)                 *"
echo "*                  Network configuration                   *"
ip -o -f inet addr show | awk '/scope global/ {print $1, $2, $3, $4, $5, $6}'
echo "************************************************************"
