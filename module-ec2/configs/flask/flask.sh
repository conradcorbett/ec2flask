#!/bin/bash

sudo systemctl stop firewalld
sudo yum update -y
sudo yum install python3 python3-devel mysql-devel gcc -y
sudo pip3 install -r /home/ec2-user/requirements.txt

#install vault agent
sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install vault