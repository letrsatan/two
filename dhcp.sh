#!/bin/bash
exec 2>/dev/null

sleep 3
mount -o remount,rw /
dhcp_nmap=$(nmap --script broadcast-dhcp-discover -e eth0 | grep "Server Identifier:" | awk '{print $4}')
ip_state=$(ip addr |grep "2:"| awk '{print $9}'| head -1)
up1=UP
down1=DOWN
dhcp_nmap_bad_status=$()
#echo $dhcp_nmap

function static {
        sed -i "s/.*iface eth0 inet manual.*/#iface eth0 inet manual/" /etc/network/interfaces
        sed -i "s/.*#iface eth0 inet static.*/iface eth0 inet static/" /etc/network/interfaces
        sed -i "s/.*#address 192.168.1.240.*/address 192.168.1.240/" /etc/network/interfaces
        sed -i "s/.*#gateway 192.168.1.1.*/gateway 192.168.1.1 /" /etc/network/interfaces
        sed -i "s/.*#netmask 255.255.255.0.*/netmask 255.255.255.0/" /etc/network/interfaces
        sed -i "s/.*#broadcast 192.168.1.255.*/broadcast 192.168.1.255/" /etc/network/interfaces
        sed -i "s/.*#network 192.168.1.0.*/network 192.168.1.0/" /etc/network/interfaces


        service dhcpcd stop
        systemctl daemon-reload
        /etc/init.d/networking restart
        systemctl daemon-reload
        ifconfig eth0 192.168.1.240 netmask 255.255.255.0 up
        route add default gw 192.168.1.1
	ifup eth0
	service sshd restart
}

function dynamic {
	sed -i "s/.*#iface eth0 inet manual.*/iface eth0 inet manual/" /etc/network/interfaces
	sed -i "s/.*iface eth0 inet static.*/#iface eth0 inet static/" /etc/network/interfaces
	sed -i "s/.*address 192.168.1.240.*/#address 192.168.1.240/" /etc/network/interfaces
	sed -i "s/.*gateway 192.168.1.1.*/#gateway 192.168.1.1 /" /etc/network/interfaces
	sed -i "s/.*netmask 255.255.255.0.*/#netmask 255.255.255.0/" /etc/network/interfaces
	sed -i "s/.*broadcast 192.168.1.255.*/#broadcast 192.168.1.255/" /etc/network/interfaces
	sed -i "s/.*network 192.168.1.0.*/#network 192.168.1.0/" /etc/network/interfaces

	service dhcpcd restart
	dhcpcd eth0
	/etc/init.d/networking restart
	systemctl daemon-reload

}


if [[ $dhcp_nmap = $dhcp_nmap_bad_status ]]; then
	if [[ $ip_state = $down1 ]]; then
		static
		echo "dhcp- eth0-"
	elif [[ $ip_state = $up1 ]]; then
		static
		echo "dhcp- eth0+"
	else
		echo "sosat"
	fi

elif [[ $dhcp_nmap != $dhcp_nmap_bad_status ]]; then
        if [[ $ip_state = $up1 ]]; then
                dynamic
                echo "dhcp+ eth0+"
        elif [[ $ip_state = $down1 ]]; then
                static
		echo "dhcp+ eth0-"
        else
                echo "sosat"
	fi

fi


#elif [[ $dhcp_nmap != $dhcp_nmap_bad_status && $ip_state = $UP ]]; then
#        dynamic
#	echo "dhcp ок"
#elif [[ $dhcp_nmap = $dhcp_nmap_bad_status && $ip_state = $UP ]]; then
#	static
#	echo "df"
#else
#	echo "adf"
#	dynamic
#fi




#if [[ $ip_state = $UP ]]
#then
#	dynamic
	#echo $ip_state
#	echo "дхцп сервер:" $dhcp_nmap
#fi




#if [[ $ip_state = $DOWN ]]
#then
#	static
#	echo $ip_state
#else
#	echo "Скрипт протёк!"
#fi

mount -o remount,ro /
