#!/bin/bash

service ntp stop


ipa=$(ifconfig  | grep 'inet addr:' | grep -v '127.0.0.1' | awk -F: '{print $3}' | awk '{print $1}' | head -1| sed 's/255/0/')
ipn=$(cat /home/starko/ntp/n_ip | awk '{print $1}' ) ##сервера, по дефолту  0.ru.pool.ntp.org
#ipad0=$( sed 's/255/0/' bcvar )
#echo $ipa

sed -i "s/.*prefer.*/server ${ipn} iburst prefer/" /etc/ntp.conf
sed -i "s/.*mask.*/restrict ${ipa} mask 255.255.255.0 nomodify notrap/" /etc/ntp.conf

service ntp restart

ntpdate -u $ipn


# ntpq -pn
# ntpdc -c sysinfo
