Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"
  config.env.enable
  config.vm.network "public_network", ip: "192.168.0.221", bridge: ENV["bridge"]
  config.vm.synced_folder ".", "/vagrant", type: "smb", smb_username: ENV["username"], smb_password: ENV["password"]

  config.vm.define "node1" do |machine|
    machine.vm.network "private_network", ip: "172.17.177.21"
  end

  config.vm.define "node2" do |machine|
    machine.vm.network "private_network", ip: "172.17.177.22"
  end

  config.vm.define 'controller' do |machine|
    machine.vm.network "private_network", ip: "172.17.177.11"
    machine.vm.provision :ansible_local do |ansible|
      ansible.playbook       = "playbook.yml"
      ansible.verbose        = false
      ansible.become = true
      ansible.install        = true
      ansible.install_mode = "pip"
      ansible.limit          = "all" # or only "nodes" group, etc.
      ansible.inventory_path = "/vagrant/inventory"
    end
  end
end