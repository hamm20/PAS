#!/bin/bash

echo "Install Java SDK 21 Amazon Corretto"
yum remove -y java
yum install -y java-21-amazon-corretto

echo "Install Docker engine"
yum update -y 
yum install docker -y
usermod -aG docker ec2-user
systemctl enable docker

echo "Install git"
yum install -y git