# v-addhost

> Скрипт добавляет новый хост в апач

## Usage
```sh
addhosts example
```
```
<VirtualHost *:80>
	DocumentRoot /sites/example/public
	ServerName   example
	ServerAlias  example.vovan
	ErrorLog     /sites/example/error.log
	CustomLog    /sites/example/access.log common
	<Directory "/sites/example/public">
		Options FollowSymLinks
		AllowOverride All
		Require all granted
	</Directory>
</VirtualHost>
```

## License
MIT © [Vladimir Rodkin](https://github.com/VovanR)
