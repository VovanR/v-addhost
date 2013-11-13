#!/bin/bash
# v-addhost, version 0.5
#
# Скрипт добавляет новый хост в апач
# Имя хоста передается в аргументе вызова скрипта
#
# github.com/VovanR/v-addhost
# Author: VovanR (Vladimir Rodkin)
# twitter.com/VovanR


# Цель:
# <VirtualHost *:80>
#     DocumentRoot    /sites/example/public
#     ServerName      example
#     ServerAlias     example.vovan
#     ErrorLog        /sites/example/error.log
#     CustomLog       /sites/example/access.log common
#     <Directory "/sites/example/public">
#         AllowOverride all
#         Options FollowSymLinks
#         Require all granted
#     </Directory>
# </VirtualHost>
#
# Случай с субдоменом:
# <VirtualHost *:80>
#     DocumentRoot    /sites/example/v2/public
#     ServerName      v2.example
#     ServerAlias     v2.example.vovan
#     ErrorLog        /sites/example/v2/error.log
#     CustomLog       /sites/example/v2/access.log common
#     <Directory "/sites/example/v2/public">
#         AllowOverride all
#         Options FollowSymLinks
#         Require all granted
#     </Directory>
# </VirtualHost>

# Пример:
# addhosts example
# addhosts v2.example



# Settings #
############

# Директория с хостами
sitesDir="/etc/apache2/sites-available/"

# Файл с хостами
sitesName="vovan"

# DNS zone (если настроена локальная зона)
zone="vovan"

# Корень проекта (обычно 'www' или 'public')
public="public"



# Logics #
##########

# Составляем путь до файла хостов
sites=$sitesDir$sitesName".conf"

# Добавить точку перед зоной
if [ -n "$zone" ];then
    zone="."$zone
fi

# Если есть хотябы один аргумент
if [ -n "$1" ];then
    # Добавить пустую строку (для красоты)
    echo "" >> $sites

    # Разбить имя сайта на массив, если аргумент задан с субдоменом (v2.example)
    site=(${1//./ })
    # Показать весь массив
    # echo ${site[@]}
    # Показать отдельные элементы массива
    # echo ${site[0]}
    # echo ${site[1]}

    # Имя домена
    domain=${site[0]}

    # Есть ли второй элемент массива
    if [ -n "${site[1]}" ];then
        domain=${site[1]}
        subdomain=${site[0]}
        echo "<VirtualHost *:80>" >> $sites
        echo -e "\tDocumentRoot\t/sites/"$domain"/"$subdomain"/"$public >> $sites
        echo -e "\tServerName\t"$subdomain"."$domain >> $sites
        echo -e "\tServerAlias\t"$subdomain"."$domain$zone >> $sites
        echo -e "\tErrorLog\t/sites/"$domain"/"$subdomain"/error.log" >> $sites
        echo -e "\tCustomLog\t/sites/"$domain"/"$subdomain"/access.log common" >> $sites
        echo -e "\t<Directory \"/sites/"$domain"/"$subdomain"/"$public"\">" >> $sites
        echo -e "\t\tOptions FollowSymLinks" >> $sites
        echo -e "\t\tAllowOverride all" >> $sites
        echo -e "\t\tRequire all granted" >> $sites
        echo -e "\t</Directory>" >> $sites
        echo "</VirtualHost>" >> $sites
    else
        echo "<VirtualHost *:80>" >> $sites
        echo -e "\tDocumentRoot\t/sites/"$domain"/"$public >> $sites
        echo -e "\tServerName\t"$domain >> $sites
        echo -e "\tServerAlias\t"$domain$zone >> $sites
        echo -e "\tErrorLog\t/sites/"$domain"/error.log" >> $sites
        echo -e "\tCustomLog\t/sites/"$domain"/access.log common" >> $sites
        echo -e "\t<Directory \"/sites/"$domain"/"$public"\">" >> $sites
        echo -e "\t\tOptions FollowSymLinks" >> $sites
        echo -e "\t\tAllowOverride all" >> $sites
        echo -e "\t\tRequire all granted" >> $sites
        echo -e "\t</Directory>" >> $sites
        echo "</VirtualHost>" >> $sites
    fi
else
    echo -e "Error: Имя проекта кто писать будет?"
    exit 2
    # Return 2
    # Exit Status: Incorrect usage
fi


# Выполнение целевой команды
# echo -e "sitesDir:\t\t"$sitesDir
# echo -e "sitesName:\t\t"$sitesName
# echo -e "sites:\t\t\t"$sites


# Для отладки
# echo -e "\n"
# echo -e "script:\t"$0
# echo -e "arguments.lenght:\t"$#
# echo -e "удачна ли предыдущая комманда ( 0 - удачная ):\t"$?
# echo -e "PID:\t"$$
# echo -e "last PID:\t"$!
# echo -e "all arguments:\t"$*
# echo -e "all arguments2:\t"$@
# echo -e "last argument of last sh:\t"$_

# Для отладки
# echo "" >> $sites
# echo $(date) >> $sites
# cat $sites


echo -e "Successful execution"
exit 0
# Return 0
# Exit Status: Success