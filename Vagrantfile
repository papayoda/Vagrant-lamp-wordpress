Vagrant.configure("2") do |config|

  config.vm.box = "hashicorp/bionic64"
  config.vm.network  "public_network"
  config.vm.provider "virtualbox" do |v|

    v.name = "Vagrant Test"
    v.memory = 2024
    v.cpus = 2
    
  end  
  config.vm.provision "shell" , path: "lamp1.sh"
  config.vm.provision "shell" , path: "wordpress1.sh"
end
