#!/bin/bash
#cd /etc
exec 2>/dev/null
mount -o remount,rw /
CYAN='\033[0;36m'
GREEN="\033[1;32m"
RED="\033[31m"
YELLOW='\033[1;33m'
NOCOLOR="\033[0m"
BLUE='\033[1;34m'

function fo()
{
	hash_var=$(tar -cf - $1 | sha1sum| awk '{print $1}')
        echo $hash_var > /boot/$1.stable

}

function funca()
{
	hash_var=$(tar -cf - $1 | sha1sum| awk '{print $1}')
	fold=/boot/hashes
	file=$(echo $1 | sed -e 's/[/]/./g')
	file_dir=$fold/$file.stable

	if ! [ -d $fold ];then
		mkdir /boot/hashes
		echo "Создаю корневую директорию для хэшей."
	fi

	#echo $file
	echo -en "${BLUE}Расположение файла с хэш-суммой:${NOCOLOR}$file_dir\n"
	#echo $fold
	echo -en "${YELLOW}Нынешняя хэш-сумма дерева:${GREEN}$hash_var${NOCOLOR}\n"

	if [ -f $file_dir ];then
		old_var=$(cat $file_dir | awk '{print $1}')
		echo -en "${CYAN}Файл:$file_dir присутствует.${NOCOLOR}\n"
		if [[ $old_var = $hash_var ]]; then
				echo -en "${CYAN}Изменения в хэш-сумме $1 отсутствуют.${NOCOLOR}\n"

			elif [[ $old_var != $hash_var ]]; then
				echo -en "${RED}ЗАРЕГИСТРИРОВАНО ИЗМЕНЕНИЕ В СТРУКТУРЕ ФС ИЛИ МЕТАДАННЫХ $1!${NOCOLOR}\n"
				echo -en "${RED}Внесите в скрипт необходимый перечень действий!${NOCOLOR}\n"
				echo $hash_var > $file_dir
				echo -en "${CYAN}Записана новая хэш-сумма для  $file_dir${NOCOLOR}\n"
			else
				echo 'скрипт скрипит'
			fi


		ls_fd=$(ls -alsh $file_dir | awk '{print $7,$8,$9}')
		c_d=$(date | awk '{print $2,$3,$4}')
		echo -en "Дата изменения:${GREEN}$ls_fd${NOCOLOR}\n"
		echo -en "Нынешняя дата:${GREEN}$c_d${NOCOLOR}\n"

	elif [ ! -f $file_dir ];then
		echo $hash_var > $file_dir
                echo -en "${CYAN}Создан новый хэш $file_dir , старый отсутствовал.${NOCOLOR}\n"
       	else
		echo "what"

	fi
	echo -e "\n\n"

}



#funca /var
funca /var/starko
funca /var/starko/buffer
funca /var/starko/media
funca /var/starko/mpd
funca /var/starko/nginx
funca /var/starko/nginx_temp
funca /var/starko/nginx_temp_big
funca /var/starko/starko
funca /var/starko/www
#funca /root
#funca /etc
#funca /etc/network
#funca /etc/crontab


mount -o remount,ro /
