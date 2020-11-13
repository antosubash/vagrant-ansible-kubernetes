#!/bin/bash

# Update hosts file
echo "[TASK 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
172.17.177.11 kmaster.example.com kmaster
172.17.177.21 kworker1.example.com kworker1
172.17.177.22 kworker2.example.com kworker2
EOF