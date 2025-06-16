#!/bin/bash

# Check Jenkins URL for up-to-date installation info: 
# https://www.jenkins.io/doc/book/installing/linux/

echo "Install Jenkins stable release"
yum remove -y java
yum install -y java-21-amazon-corretto
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install -y jenkins
systemctl enable jenkins


# Install Git client, to clone GitHub repos
echo "Install git"
yum install -y git


# Copies private SSH key used to deploy Jenkins workers/agents to JENKINS_HOME
echo "Setup SSH key"
mkdir /var/lib/jenkins/.ssh
touch /var/lib/jenkins/.ssh/known_hosts
chown -R jenkins:jenkins /var/lib/jenkins/.ssh
chmod 700 /var/lib/jenkins/.ssh
mv /tmp/id_rsa /var/lib/jenkins/.ssh/id_rsa
chmod 600 /var/lib/jenkins/.ssh/id_rsa
chown -R jenkins:jenkins /var/lib/jenkins/.ssh/id_rsa

# Move Groovy scripts to init.groovy.d from /tmp
echo "Configure Jenkins"
mkdir -p /var/lib/jenkins/init.groovy.d
mv /tmp/scripts/*.groovy /var/lib/jenkins/init.groovy.d/
chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d
mv /tmp/config/jenkins /etc/sysconfig/jenkins
chmod +x /tmp/config/install-plugins.sh
mkdir -p /var/lib/jenkins/plugins
chown -R jenkins:jenkins /var/lib/jenkins/plugins
# Install needed dependencies by running install-plugins.sh
bash /tmp/config/install-plugins.sh

echo "Listing directory of /var/lib/jenkins/plugins"
ls /var/lib/jenkins/plugins

# Startup Jenkins service
echo "Starting up jenkins service"
systemctl start jenkins