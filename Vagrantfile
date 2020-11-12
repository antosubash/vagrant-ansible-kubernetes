Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"
  # config.ssh.insert_key = false
  config.env.enable
  config.vm.network "public_network", ip: "192.168.0.221", bridge: ENV["bridge"]
  config.vm.synced_folder ".", "/vagrant", type: "smb", smb_username: ENV["username"], smb_password: ENV["password"]

  # config.vm.provider "virtualbox" do |v|
  #   v.customize ["modifyvm", :id, "--cpus", 2]
  # end

  config.vm.define "node1" do |machine|
    machine.vm.network "private_network", ip: "172.17.177.21"
  end

  config.vm.define "node2" do |machine|
    machine.vm.network "private_network", ip: "172.17.177.22"
  end

  config.vm.define 'controller' do |machine|
    machine.vm.network "private_network", ip: "172.17.177.11"

    machine.vm.provider "virtualbox" do |v|
      v.cpus = 2
    end

    machine.vm.provision :ansible_local do |ansible|
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