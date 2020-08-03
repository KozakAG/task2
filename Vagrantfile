
BOX_IMAGE = "ubuntu/bionic64"
Vagrant.configure("2") do |config|
        config.vm.define "database3" do |subconfig|
            subconfig.vm.provider "virtualbox" do |v|
                v.name = "db3_vm"
            end
            subconfig.vm.box = BOX_IMAGE
            subconfig.vm.network "private_network", ip: "192.168.63.10"
            subconfig.vm.provider "virtualbox" do |vb|
                vb.memory = "1024"
                vb.cpus = "1"
            end
            subconfig.vm.provision :shell, path: "db3_vm.sh"
        end
        config.vm.define "application3" do |subconfig|
            subconfig.vm.provider "virtualbox" do |v|
                v.name = "app3_vm"
            end
            subconfig.vm.box = BOX_IMAGE
            subconfig.vm.network "private_network", ip: "192.168.63.15"
            subconfig.vm.provider "virtualbox" do |vb|
                vb.memory = "1024"
                vb.cpus = "1"
            end
            subconfig.vm.provision :shell, path: "app3_vm.sh"
        end

end
