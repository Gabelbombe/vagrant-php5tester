# -*- mode: ruby -*-
# vi: set ft=ruby :

# NOTE: If you are going to connect to your Github from the box, setup a sshkey and uncomment below 
# require 'shellwords'
#
# def bash(command)
#   escaped_command = Shellwords.escape(command)
#   system "bash -c #{escaped_command}"
# end
#
# # The RSA file below MUST BE the RSA that you use
# # to connect to Github, otherwise you cannot clone.
# bash("key_file=~/.ssh/github_rsa; [[ -z $(ssh-add -L | grep $key_file) ]] && ssh-add $key_file")

Vagrant.configure("2") do | config |

  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "trusty"

  config.vm.provision :shell, :path => "scripts/mute_ssh.sh"
  config.vm.provision :shell, :path => "scripts/bootstrap.sh"

  # Visit the site at http://192.168.50.4
  config.vm.network :private_network, ip: "192.168.50.13"

  # Requires: vagrant plugin install vagrant-vbguest
  config.vbguest.auto_update = false

  # Required for passing ssh keys
  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do | vb |
    vb.customize [ "modifyvm", :id, "--memory", "1024" ]
    vb.name = "php.io"
  end

end
