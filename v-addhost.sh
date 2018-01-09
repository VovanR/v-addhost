#!/usr/bin/env bash
# v-addhost, version 0.6
#
# Скрипт добавляет новый хост в апач
# Имя хоста передается в аргументе вызова скрипта
#
# github.com/VovanR/v-addhost
# Author: VovanR (Vladimir Rodkin)
# twitter.com/VovanR


# Цель:
# <VirtualHost *:80>
# 	DocumentRoot /sites/example/public
# 	ServerName   example
# 	ServerAlias  example.vovan
# 	ErrorLog     /sites/example/error.log
# 	CustomLog    /sites/example/access.log common
# 	<Directory "/sites/example/public">
# 		Options FollowSymLinks
# 		AllowOverride All
# 		Require all granted
# 	</Directory>
# </VirtualHost>

# Пример использования:
# addhosts example



# Settings #
############

# Директория с хостами
sitesAvailableDir="/etc/apache2/sites-available"
sitesEnabledDir="/etc/apache2/sites-enabled"

# Файл с хостами
sitesName=$(whoami)".conf"
# DNS zone (если настроена локальная зона)
zone="vovan"

# Директория проектов
sitesDir="/sites"
# Корень проекта (обычно 'www' или 'public')
public="public"



# Logics #
##########

# check if user is root
if [ $(whoami) == "root" ] ; then
	echo -e "\nThis script must be run as a normal user with sudo privileges\n"
	exit 2
	# Return 2
	# Exit Status: Incorrect usage
fi

# Составляем путь до файла хостов
sites=${sitesAvailableDir}"/"${sitesName}


# Добавить точку перед зоной
if [ -n "${zone}" ]; then
	zone="."${zone}
fi

# Если есть хотябы один аргумент
if [ -n "$1" ]; then
	# Имя домена
	domain=$1

# Пишим в файл конфига
sudo tee -a ${sites} << EOF

<VirtualHost *:80>
	DocumentRoot ${sitesDir}/${domain}/${public}
	ServerName   ${domain}
	ServerAlias  ${domain}${zone}
	ErrorLog     ${sitesDir}/${domain}/error.log
	CustomLog    ${sitesDir}/${domain}/access.log common
	<Directory "${sitesDir}/${domain}/${public}">
		Options FollowSymLinks
		AllowOverride All
		Require all granted
	</Directory>
</VirtualHost>
EOF

else
	echo -e "Error: Имя проекта кто писать будет?"
	exit 2
	# Return 2
	# Exit Status: Incorrect usage
fi


# Включаем файл хостов
if [ ! -e ${sitesEnabledDir}"/"${sitesName} ]; then
	if [ ! -e ${sites} ]; then
		echo -e "Error: File \""${sites}"\" does not exist";
		exit 2
		# Return 2
		# Exit Status: Incorrect usage
	else
		sudo a2ensite ${sitesName};
	fi
fi


# Перезапускаем апач
sudo service apache2 restart


echo -e "Successful execution"
exit 0
# Return 0
# Exit Status: Success
