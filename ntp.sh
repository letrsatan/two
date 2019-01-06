#!/bin/bash
#!/usr/bin/sshpass
#exec 2>/dev/null

hostname -I > /home/starko/ntp/host_ip
my_ip=$(hostname -I)
ipfind=$(ifconfig  | grep 'inet addr:' | grep -v '127.0.0.1' | awk -F: '{print $3}' | awk '{print $1}' | head -1| sed 's/255/1/')
nmap --open -sV $ipfind/24 -p 8501|grep 'Nmap scan report for'| awk '{print $5}'|grep -v $my_ip > /home/starko/ntp/slaves


function fuu {
  scpv=$(awk "(NR == $count)" /home/starko/ntp/slaves ) ##берем значение
  sshpass -p 'starko' scp -o  StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null /home/starko/ntp/host_ip  starko@$scpv:/home/starko/ntp/n_ip
##echo $count
}


var1=$(wc /home/starko/ntp/slaves | awk '{print $1}')
#echo $var1
count=1
##echo count

while [ $count -le $var1 ]
do
        fuu
        count=$(( $count + 1 ))

done

service ntp stop

ipa=$(ifconfig  | grep 'inet addr:' | grep -v '127.0.0.1' | awk -F: '{print $3}' | awk '{print $1}' | head -1| sed 's/255/0/')
ipn=$(cat /home/starko/ntp/def_ip | awk '{print $1}' ) ##сервера, по дефолту  0.ru.pool.ntp.org
cp /home/starko/ntp/def_ip /home/starko/ntp/n_ip
sed -i "s/.*prefer.*/server ${ipn} iburst prefer/" /etc/ntp.conf
sed -i "s/.*mask.*/restrict ${ipa} mask 255.255.255.0 nomodify notrap/" /etc/ntp.conf

service ntp restart

#result=«$(./)»
ntpdate -u $ipn
