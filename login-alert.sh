#!/bin/bash
# Aoo Installation Login Alert wrapper # Version 1.0.0.1
# Script Developed by Apivat Pattana-Anurak
# SysAdmin & Programmer Form #Bangkok #Thailand

yum install mailx -y
curl -O https://raw.githubusercontent.com/aoopa/linux-centos/master/.bashrc

####################### End Script ##########################
echo "************************************************************"
echo "*                      Hello : "$USER"                        *"
echo "*                 PLEASE REBOOT SERVER NOW                 *"
echo "*      Current date : $(date)         *"
echo "*                 Hostname   @ $(hostname)                 *"
echo "*                  Network configuration                   *"
ip -o -f inet addr show | awk '/scope global/ {print $1, $2, $3, $4, $5, $6}'
echo "************************************************************"
