# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config| 
  config.vm.synced_folder ".", "/vagrant" 
  config.vm.box = "bento/centos-7.1"
  config.vbguest.auto_update = false
  config.vm.network "private_network", ip: "192.168.33.20"
  config.vm.hostname = "terraform"
  config.vm.provision "ansible_local" do |ansible|
    ansible.verbose        = true
    ansible.raw_arguments  = ["-connection=local"]
    #ansible.galaxy_command = 'ansible-galaxy install rvm_io.ruby --roles-path=/home/vagrant/.ansible/roles --ignore-errors --force'
    #ansible.galaxy_command = 'ansible-galaxy install secfigo.terraform --roles-path=/home/vagrant/.ansible/roles --ignore-errors --force'
    ansible.playbook = "test.yml"
  end
  config.vm.provision :shell, inline: "ansible-galaxy install tommarshall.awscli --roles-path=/root/.ansible/roles --ignore-errors --force"
  config.vm.provision :shell, inline: "ansible-galaxy install secfigo.terraform --roles-path=/root/.ansible/roles --ignore-errors --force"
  config.vm.provision :shell, inline: "ansible-playbook --connection=local  /vagrant/playbook.yml"
end