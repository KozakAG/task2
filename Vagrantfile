
BOX_IMAGE = "centos/7"
#
DB0_IP = "192.168.63.10"
BE0_IP = "192.168.63.15"
FE0_IP = "192.168.63.20"
#
Vagrant.configure("2") do |config|
        config.vm.define "database" do |db|
            db.vm.provider "virtualbox" do |v|
                v.name = "db_vm"
            end
            db.vm.box = "bento/ubuntu-18.04"
            db.vm.network "private_network", ip: DB0_IP
            db.vm.provider "virtualbox" do |vb|
                vb.memory = "1024"
                vb.cpus = "1"
            end
            db.vm.provision :shell, path: "db3_vm.sh"
        end
        config.vm.define "backend" do |be|
            be.vm.provider "virtualbox" do |v|
                v.name = "be_vm"
            end
            be.vm.box = BOX_IMAGE
            be.vm.network "private_network", ip: BE0_IP
            be.vm.provider "virtualbox" do |vb|
                vb.memory = "1024"
                vb.cpus = "1"
            end
            be.vm.provision :shell, path: "be3_vm.sh"
        end
        config.vm.define "frontend" do |fe|
            fe.vm.provider "virtualbox" do |v|
                v.name = "fe_vm"
            end
            fe.vm.box = BOX_IMAGE
            fe.vm.network "private_network", ip: FE0_IP
            fe.vm.provider "virtualbox" do |vb|
                vb.memory = "1024"
                vb.cpus = "1"
            end
            fe.vm.provision :shell, path: "fe3_vm.sh"
        end
end
