#!/bin/bash

set -e

plugin_dir=/var/lib/jenkins/plugins
file_owner=jenkins.jenkins

# Comment out mkdir since it's already created in setup.sh script
#mkdir -p /var/lib/jenkins/plugins

installPlugin() {
    if [ -f ${plugin_dir}/${1}.hpi -o -f ${plugin_dir}/${1}.jpi ]; then
        if [ "$2" == "1" ]; then
            return 1
        fi
        echo "Skipped: $1 (already installed)"
        return 0
    else
        echo "Installing: $1"
        curl -L --silent --output ${plugin_dir}/${1}.hpi  https://updates.jenkins-ci.org/latest/${1}.hpi
        return 0
    fi
}

while read -r plugin
do 
    installPlugin "$plugin"
done < "/tmp/config/plugins.txt"

changed=1
maxloops=100

while [ "$changed" == "1" ]; do
    echo "Check for missing dependecies..."
    if [ $maxloops -lt 1 ]; then
        echo "Max loop count reached - probably a bug in this script: $0"
        exit 1
    fi
    ((maxloops--))
    changed=0
    for f in ${plugin_dir}/*.hpi; do
        # without optionals
        #deps=$( unzip -p ${f} META-INF/MANIFEST.MF | tr -d '\r' | sed -e ':a;N;$!ba;s/\n //g' | grep -e "^Plugin-Dependencies: " | awk '{ print $2 }' | tr ',' '\n' | grep -v "resolution:=optional" | awk -F ':' '{ print $1 }' | tr '\n' ' ' )
        # with optionals
        deps=$( unzip -p ${f} META-INF/MANIFEST.MF | tr -d '\r' | sed -e ':a;N;$!ba;s/\n //g' | grep -e "^Plugin-Dependencies: " | awk '{ print $2 }' | tr ',' '\n' | awk -F ':' '{ print $1 }' | tr '\n' ' ' )
        for plugin in $deps; do
            installPlugin "$plugin" 1 && changed=1
        done
    done
done

echo "fixing permissions"

chown ${file_owner} ${plugin_dir} -R

echo "all done"