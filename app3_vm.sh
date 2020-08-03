#!/bin/bash

install_requirements() {
	sudo apt update
	sudo apt install mc -y
	sudo apt install maven -y
}

install_java(){
	sudo apt install openjdk-8-jdk -y
	echo 'JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java"' > /etc/profile.d/java.sh
	source /etc/profile.d/java.sh
}

install_maven() {
	wget https://www-us.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -P /tmp
	sudo tar xf /tmp/apache-maven-3.6.3-bin.tar.gz -C /opt
}

setup_maven() {
	sudo ln -s /opt/apache-maven-3.6.3/ /opt/maven
	sudo chown -R root:root /opt/apache-maven-3.6.3
	sudo ln -s /opt/apache-maven-3.6.3 /opt/apache-maven
	echo 'export PATH=$PATH:/opt/apache-maven/bin' | sudo tee -a /etc/profile
	source /etc/profile
}

clone_edit_config() {
	
	mkdir /home/Java
	cd /home/Java
	sudo git clone https://github.com/yurkovskiy/eSchool
	
	sudo sed -i -e "s|localhost:3306/eschool|192.168.63.10:3306/eschool|g" /home/Java/eSchool/src/main/resources/application.properties
	sudo sed -i -e "s/DATASOURCE_USERNAME:root/DATASOURCE_USERNAME:eschool/g" /home/Java/eSchool/src/main/resources/application.properties
	sudo sed -i -e "s/DATASOURCE_PASSWORD:root/DATASOURCE_PASSWORD:cossack/g" /home/Java/eSchool/src/main/resources/application.properties
	sudo sed -i -e "s|https://fierce-shore-32592.herokuapp.com|http://$ext_ip|g" /home/Java/eSchool/src/main/resources/application.properties

	sudo sed -i -e "s|35.240.41.176:8443|$ext_ip:8080|g" /home/Java/eSchool/src/main/resources/application-production.properties
	sudo sed -i -e "s/DATASOURCE_USERNAME:root/DATASOURCE_USERNAME:eschool/g" /home/Java/eSchool/src/main/resources/application-production.properties
	sudo sed -i -e "s/DATASOURCE_PASSWORD:CS5eWQxnja0lAESd/DATASOURCE_PASSWORD:cossack/g" /home/Java/eSchool/src/main/resources/application-production.properties
	sudo sed -i -e "s|35.242.199.77:3306/ejournal|192.168.63.10:3306/eschool|g" /home/Java/eSchool/src/main/resources/application-production.properties

}
build_backend() {

	cd /home/Java/eSchool/
	sudo mvn package -DskipTests
	cd /home/Java/eSchool/target/
#	sudo java -jar eschool.jar
}

build_frontend() {

	cd /home/Java/
	sudo su
	sudo apt install -y gcc-c++ make
	curl -sL https://deb.nodesource.com/setup_8.x | sudo bash -
	sudo apt install -y nodejs
	sudo npm install -g @angular/cli@7.0.7
	sudo npm install --save-dev  --unsafe-perm node-sass

	sudo npm install

}

install_requirements
install_java
install_maven
setup_maven

clone_edit_config
build_backend
build_frontend
