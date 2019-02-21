#!/bin/bash
# Aoo Basic installation wrapper # Version 1.0.0.5
# Script Developed by Apivat Pattana-Anurak
# SysAdmin & Programmer Form #Bangkok #Thailand 

################## Step1 basic install & update ####################
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
wget dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm
rpm -ihv epel-release-7-11.noarch.rpm 
yum -y install epel-release
yum install htop -y
yum install atop -y
yum install iftop -y
yum install nmon -y


################## Step4 Install Netdata Monitor ####################
echo -e '\e[1;36mServer Status Show Apache Server Status .......................................................OK\e[0m';
sed -i 's/#ExtendedStatus/ExtendedStatus/' /etc/httpd/conf/extra/httpd-info.conf


echo -e '\e[1;36mInstall Netdata (Traffic/CPU Monitoring Graph) http://yourip:19999 ............................OK\e[0m';
bash <(curl -Ss https://my-netdata.io/kickstart.sh)
yum install -y MySQL-python --disableexcludes=all
cat <<EOF >>/etc/netdata/python.d/nginx.conf
local:
  url  : 'http://127.0.0.1/nginx_status'
EOF
cat <<EOF >>/etc/netdata/python.d/mysql.conf
local:
    socket: '/var/lib/mysql/mysql.sock'
    user: 'netdata'
    pass: '7kT6H0Jw'
EOF
DA_MYSQL=/usr/local/directadmin/conf/mysql.conf
MYSQLPASSWORD=`grep "^passwd=" ${DA_MYSQL} | cut -d= -f2`
mysql -u da_admin -p$MYSQLPASSWORD <<EOF
GRANT USAGE ON *.* TO netdata@localhost IDENTIFIED BY '7kT6H0Jw';
FLUSH PRIVILEGES;
EOF
perl -pi -e 's/CONFIGURATION STARTS HERE/CONFIGURATION STARTS HERE\nqueue_list_requires_admin = false/' /etc/exim.conf
systemctl restart netdata

cat <<EOF >>/etc/nginx/nginx-includes.conf
upstream netdata {
    server 127.0.0.1:19999;
    keepalive 64;
}
EOF

cat <<EOF >>/etc/nginx/nginx-info.conf
    location = /netdata {
        return 301 /netdata/;
    }

    location ~ /netdata/(?<ndpath>.*) {
        proxy_redirect off;
        proxy_set_header Host \$host;

        proxy_set_header X-Forwarded-Host \$host;
        proxy_set_header X-Forwarded-Server \$host;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_http_version 1.1;
        proxy_pass_request_headers on;
        proxy_set_header Connection "keep-alive";
        proxy_store off;
        proxy_pass http://netdata/\$ndpath\$is_args\$args;

        gzip on;
        gzip_proxied any;
        gzip_types *;
    }
EOF

#################### End Script #######################
echo "************************************************"
echo "*           PLEASE REBOOT SERVER NOW           *"
echo "************************************************"
