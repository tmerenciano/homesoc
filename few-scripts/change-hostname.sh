#!/bin/bash
read -p 'New hostname: ' HOSTNAME

echo $HOSTNAME > /etc/hostname
sed -i "s/^127\.0\.1\.1\s\+debian$/127.0.1.1       $HOSTNAME/" /etc/hosts
