#!/bin/bash

install_requirements(){

	sudo setenforce 0
	sudo yum update -y
	sudo yum install java-1.8.0-openjdk wget git -y
	sudo yum install maven -y
	sudo yum install mc -y
	sudo su
}

firewall(){
# Open 8080 port to reach web app from the host machine
	sudo yum install firewalld
	sudo systemctl enable firewalld
	sudo systemctl start firewalld
	sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
	sudo firewall-cmd --reload
}

install_maven() {

	sudo wget https://www-us.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -P /tmp
	sudo tar xf /tmp/apache-maven-3.6.3-bin.tar.gz -C /opt
	sudo ln -s /opt/apache-maven-3.6.3/ /opt/maven
}

setup_maven() {

FILE="/etc/profile.d/maven.sh"

/bin/cat <<EOM >$FILE
export JAVA_HOME=/usr/lib/jvm/jre-openjdk
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=${M2_HOME}/bin:${PATH}
EOM
	sudo chmod +x /etc/profile.d/maven.sh
	source /etc/profile.d/maven.sh
}


clone_edit_config() {

	
	sudo mkdir /home/Java
	cd /home/Java
	sudo git clone https://github.com/yurkovskiy/eSchool
	
	sudo sed -i -e "s|localhost:3306/eschool|192.168.63.10:3306/eschool|g" /home/Java/eSchool/src/main/resources/application.properties
	sudo sed -i -e "s/DATASOURCE_USERNAME:root/DATASOURCE_USERNAME:eschool/g" /home/Java/eSchool/src/main/resources/application.properties
	sudo sed -i -e "s/DATASOURCE_PASSWORD:root/DATASOURCE_PASSWORD:cossack/g" /home/Java/eSchool/src/main/resources/application.properties
	sudo sed -i -e "s|https://fierce-shore-32592.herokuapp.com|http://192.168.63.15:8080|g" /home/Java/eSchool/src/main/resources/application.properties
	

	sudo sed -i -e "s|35.240.41.176:8443|192.168.63.15:8080|g" /home/Java/eSchool/src/main/resources/application-production.properties
	sudo sed -i -e "s/DATASOURCE_USERNAME:root/DATASOURCE_USERNAME:eschool/g" /home/Java/eSchool/src/main/resources/application-production.properties
	sudo sed -i -e "s/DATASOURCE_PASSWORD:CS5eWQxnja0lAESd/DATASOURCE_PASSWORD:cossack/g" /home/Java/eSchool/src/main/resources/application-production.properties
	sudo sed -i -e "s|35.242.199.77:3306/ejournal|192.168.63.10:3306/eschool|g" /home/Java/eSchool/src/main/resources/application-production.properties

}

build_backend_and_run() {

	cd /home/Java/eSchool/
	sudo mvn package -DskipTests
	cd /home/Java/eSchool/target/
    sudo java -jar eschool.jar &
    sleep 25

}
	

install_requirements
firewall
install_maven
setup_maven
clone_edit_config
build_backend_and_run
