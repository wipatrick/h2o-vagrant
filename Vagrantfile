# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "bento/centos-7.1"

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
  end

  N = 3
  (1..N).each do |node_id|

    config.vm.define "node#{node_id}" do |node|
      node.vm.network "private_network", ip: "192.168.33.#{9+node_id}"
      node.vm.hostname = "node#{node_id}"

      # Only execute once the Ansible provisioner,
      # when all the machines are up and ready.
      if node_id == N
        node.vm.provision "ansible" do |ansible|

          # Disable default limit to connect to all the machines
          ansible.limit = 'all'
          ansible.playbook = "playbook.yml"

        end
      end

    end
  end

end
