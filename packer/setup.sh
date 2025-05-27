#!/bin/bash

# Check Jenkins URL for up-to-date installation info: 
# https://www.jenkins.io/doc/book/installing/linux/

echo ""
echo "Install Jenkins stable release"
yum remove -y java
yum install -y java-21-amazon-corretto
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install -y jenkins
systemctl enable jenkins
systemctl start jenkins
