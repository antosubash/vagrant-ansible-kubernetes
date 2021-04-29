# -*- mode: ruby -*-
# vi: set ft=ruby :

# ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  # config.vm.provision "shell", path: "bootstrap.sh"
  # config.ssh.insert_key = false
  config.env.enable
  # config.vm.boot_timeout = 5
  config.vm.network "public_network", ip: "192.168.0.221", bridge: ENV["bridge"]
  config.vm.synced_folder ".", "/vagrant", type: "smb", smb_username: ENV["username"], smb_password: ENV["password"]
  config.ssh.connect_timeout = 20
  # Kubernetes Master Server
  config.vm.define "kmaster" do |kmaster|
    kmaster.vm.hostname = "kmaster.example.com"
    kmaster.vm.network "private_network", ip: "172.17.177.11"
    kmaster.vm.provider "virtualbox" do |v|
      v.name = "kmaster"
      v.memory = 4096 
      v.cpus = 2
      # Prevent VirtualBox from interfering with host audio stack
      v.customize ["modifyvm", :id, "--audio", "none"]
      v.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]
      v.customize ["modifyvm", :id, "--uartmode1", "file", File::NULL]
    end
    kmaster.vm.provider :libvirt do |v|
      v.memory = 4096
      v.nested = true
      v.cpus = 2
    end

    kmaster.vm.provision "master", type: 'ansible_local', run: "never" do |ansible|
      ansible.playbook       = "master-playbook.yml"
      ansible.become = true
      ansible.limit          = "all" # or only "nodes" group, etc.
      ansible.inventory_path = "/vagrant/inventory"
      ansible.extra_vars = { ansible_python_interpreter:"/usr/bin/python3", node_ip: "172.17.177.11" }
      ansible.raw_arguments = ["--connection=paramiko"]
    end

    kmaster.vm.provision "tool", type: 'ansible_local', run: "never" do |ansible|
      ansible.playbook       = "tools-playbook.yml"
      ansible.become = true
      ansible.limit          = "all" # or only "nodes" group, etc.
      ansible.inventory_path = "/vagrant/inventory"
      ansible.extra_vars = { ansible_python_interpreter:"/usr/bin/python3", node_ip: "172.17.177.11" }
      ansible.raw_arguments = ["--connection=paramiko"]
    end
  end


  NodeCount = 2
  # Kubernetes Worker Nodes
  (1..NodeCount).each do |i|
    config.vm.define "kworker#{i}" do |workernode|
      workernode.vm.hostname = "kworker#{i}.example.com"
      workernode.vm.network "private_network", ip: "172.17.177.2#{i}"
      workernode.vm.provider "virtualbox" do |v|
        v.name = "kworker#{i}"
        v.memory = 4096
        v.cpus = 2
        # Prevent VirtualBox from interfering with host audio stack
        v.customize ["modifyvm", :id, "--audio", "none"]
        v.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]
        v.customize ["modifyvm", :id, "--uartmode1", "file", File::NULL]
      end
      workernode.vm.provider :libvirt do |v|
        v.memory = 4096
        v.nested = true
        v.cpus = 2
      end
      workernode.vm.provision "node", type: "ansible_local", run: "never" do |ansible|
        ansible.playbook       = "node-playbook.yml"
        ansible.become = true
        ansible.limit          = "all" # or only "nodes" group, etc.
        ansible.inventory_path = "/vagrant/inventory"
        ansible.extra_vars = { ansible_python_interpreter:"/usr/bin/python3", node_ip: "172.17.177.2#{i}", }
        ansible.raw_arguments = ["--connection=paramiko"]
      end
    end
  end
end