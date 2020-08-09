#!/bin/bash

install_requirements() {
	sudo apt update
	sudo apt install mc -y
	}

setup_mysql() {

	sudo apt install mysql-server -y

mysql -u root <<-EOF
	UPDATE mysql.user SET Password=PASSWORD('') WHERE User='root';
	DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
	DELETE FROM mysql.user WHERE User='';
	DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
	FLUSH PRIVILEGES;
	EOF
	}

create_database() {
	user_db_pass="1234"
	mysql -u root <<-EOF
	CREATE DATABASE eschool DEFAULT CHARSET = utf8 COLLATE = utf8_unicode_ci;
	GRANT ALL ON eschool.* TO 'eschool'@'%' IDENTIFIED BY "$user_db_pass" WITH GRANT OPTION;
	FLUSH PRIVILEGES;
	EOF
	}

bind_addr_database() {
	sed -i.bak '/bind-address/ s/#bind-address=127.0.0.1/bind-address=0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
	sudo systemctl restart mysql

	#sudo systemctl stop iptables
	#sudo apt-get remove ufw -y
	#sudo apt-get install firewall-applet -y

	#sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
	#sudo firewall-cmd --reload
	# firewall-cmd --zone=public --list-ports 
	}

	install_requirements
	setup_mysql
	create_database
	bind_addr_database
