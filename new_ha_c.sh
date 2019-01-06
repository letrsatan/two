#!/bin/bash
exec 2>/dev/null
mount -o remount,rw /
#hash_root=$(tar -cf - /root | md5sum| awk '{print $1}' )

function hash_stable_root {
	HSR_var=$(cat /boot/hash_stable| awk '{print $1}' )
}

function hash_root {
	hash_root_var=$(tar -cf - /root | md5sum| awk '{print $1}')
	#echo $hash_root_var
}


function re_hash_root {
if [ -f "/boot/hash_stable" ];then
	echo "hash_stable +";
elif [ ! -f "/boot/hash_stable" ];then
	echo $hash_root_var > /boot/hash_stable
	#echo "new hash"
fi
}


hash_root
re_hash_root
hash_stable_root

sleep 1
#hash_stable_root=$(cat /boot/hash_stable| awk '{print $1}' )
#echo $hash_stable_root

if [[ $HSR_var = $hash_root_var ]]; then
	echo "изменений в папке рута нет"
elif [[ $HSR_var != $hash_root_var ]]; then
	echo "ЗАРЕГИСТРИРОВАНО ИЗМЕНЕНИЕ В СТРУКТУРЕ ИЛИ МЕТАДАННЫХ /root, делаю копию nm.sh"
	cp /boot/nm.sh /root
	echo "Прежняя КС:" $HSR_var
	chmod +777 /root/nm.sh
	rm /boot/hash_stable
	hash_root
	re_hash_root
	hash_stable_root
	echo "Новая КС:" $HSR_var
fi
