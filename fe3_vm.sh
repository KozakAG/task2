#!/bin/sh

install_requirements(){
	sudo yum -y install epel-release
	sudo yum install -y dnf
	dnf update -y
	setenforce 0
	yum install -y mc
	dnf install httpd git  wget -y
	systemctl start httpd
	sudo yum install nano -y
	sudo yum install nodejs -y
	}

# Open http (port 80)
firewall(){
	systemctl enable firewalld
	systemctl start firewalld
	firewall-cmd --permanent --add-service=http
	firewall-cmd --reload
	}
	
install_yarn_angular(){	
	sudo wget https://nodejs.org/dist/v9.9.0/node-v9.9.0-linux-x64.tar.gz
	sudo tar --strip-components 1 -xzvf node-v* -C /usr/local

	sudo npm install -g yarn
	sudo npm install -g @angular/cli@7.0.7
	}

clone_build_proj(){
	git clone https://github.com/yurkovskiy/final_project
	chown vagrant:vagrant /home/vagrant/final_project
	sudo sed -i -e "s|https://fierce-shore-32592.herokuapp.com|http://192.168.63.15:8080|g" /home/vagrant/final_project/src/app/services/token-interceptor.service.ts
	cd final_project/
	yarn install
	ng build --prod
	sudo mkdir /var/www/eschool
	sudo chown -R vagrant:vagrant /var/www/eschool/
	sudo cp -r /home/vagrant/final_project/dist/eSchool/* /var/www/eschool/
	sudo wget "https://dtapi.if.ua/~yurkovskiy/IF-108/htaccess_example_fe" -O /var/www/eschool/.htaccess
 }

add_VirtualHost(){	
sudo cat <<_EOF > /etc/httpd/conf.d/eschool.conf
<VirtualHost *:80>
	DocumentRoot /var/www/eschool
	<Directory /var/www/eschool>
		Options -Indexes +FollowSymLinks
		AllowOverride All
	</Directory>
	ErrorLog /var/log/httpd/eschool-error.log
	CustomLog /var/log/httpd/eschool-access.log combined
</VirtualHost>
_EOF

	sudo systemctl restart httpd
}

install_requirements
firewall
install_yarn_angular
clone_build_proj
add_VirtualHost