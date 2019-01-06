#!/bin/bash
my_ip=$(hostname -I)
#echo адрес этого хоста: $my_ip
ipa=$(ifconfig  | grep 'inet addr:' | grep -v '127.0.0.1' | awk -F: '{print $3}' | awk '{print $1}' | head -1| sed 's/255/1/')
#ipa1=$"${ipa}/24"
nmap --open -sV $ipa/24 -p 8501|grep 'Nmap scan report for'| awk '{print $5}'|grep -v $my_ip > /home/starko/ntp/slaves
#echo шлюз: $ipa
hostname -I > /home/starko/ntp/host_ipp
#sshpass -p 'starko' scp /etc/ntp.conf starko@192.168.88.252:/home/starko/ss   
