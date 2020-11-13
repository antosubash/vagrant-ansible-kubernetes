# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"
  # config.vm.provision "shell", path: "bootstrap.sh"
  # config.ssh.insert_key = false
  config.env.enable
  config.vm.network "public_network", ip: "192.168.0.221", bridge: ENV["bridge"]
  config.vm.synced_folder ".", "/vagrant", type: "smb", smb_username: ENV["username"], smb_password: ENV["password"]
  
  NodeCount = 2
  # Kubernetes Worker Nodes
  (1..NodeCount).each do |i|
    config.vm.define "kworker#{i}" do |workernode|
      workernode.vm.hostname = "kworker#{i}.example.com"
      workernode.vm.network "private_network", ip: "172.17.177.2#{i}"
      workernode.vm.provider "virtualbox" do |v|
        v.name = "kworker#{i}"
        v.memory = 2048
        v.cpus = 2
        # Prevent VirtualBox from interfering with host audio stack
        v.customize ["modifyvm", :id, "--audio", "none"]
      end
      workernode.vm.provider :libvirt do |v|
        v.memory = 2048
        v.nested = true
        v.cpus = 2
      end
    end
  end

  # Kubernetes Master Server
  config.vm.define "kmaster" do |kmaster|
    kmaster.vm.hostname = "kmaster.example.com"
    kmaster.vm.network "private_network", ip: "172.17.177.11"
    kmaster.vm.provider "virtualbox" do |v|
      v.name = "kmaster"
      v.memory = 2048
      v.cpus = 2
      # Prevent VirtualBox from interfering with host audio stack
      v.customize ["modifyvm", :id, "--audio", "none"]
    end
    kmaster.vm.provider :libvirt do |v|
      v.memory = 2048
      v.nested = true
      v.cpus = 2
    end

    kmaster.vm.provision "ansible_local" do |ansible|
      ansible.playbook       = "playbook.yml"
      ansible.become = true
      ansible.limit          = "all" # or only "nodes" group, etc.
      ansible.inventory_path = "/vagrant/inventory"
      # ansible.pip_args = "-r /vagrant/requirements.txt"
      # ansible.galaxy_role_file = "requirements.yml"
      # ansible.galaxy_roles_path = "/etc/ansible/roles"
      # ansible.galaxy_command = "sudo ansible-galaxy install --role-file=%{role_file} --roles-path=%{roles_path} --force"
      ansible.extra_vars = { ansible_python_interpreter:"/usr/bin/python3" }
      ansible.raw_arguments = ["--connection=paramiko"]
    end
  end

end