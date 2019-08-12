Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.disksize.size = "50GB"
  config.vm.network "private_network", ip: "192.168.50.2"

  config.vm.provider "virtualbox" do |v|
    v.gui = false
    v.memory = 4096
    v.cpus = 2
  end
  
  config.vm.provision "file", source: "~/.gitconfig", destination: "/home/vagrant/.gitconfig"
  config.vm.provision "file", source: "~/.ssh/id_rsa", destination: "/home/vagrant/.ssh/id_rsa"
  config.vm.provision "file", source: "~/.ssh/config", destination: "/home/vagrant/.ssh/config"
  config.vm.provision "file", source: "~/.kube/config", destination: "/home/vagrant/.kube/config"
  
  config.vm.provision ".ssh", type: "shell", inline: <<-SCRIPT
    chown vagrant:vagrant /home/vagrant/.ssh
    chown vagrant:vagrant /home/vagrant/.ssh/id_rsa
    chown vagrant:vagrant /home/vagrant/.ssh/config
    chmod 600 /home/vagrant/.ssh/id_rsa
    chmod 600 /home/vagrant/.ssh/config
  SCRIPT
  
  config.vm.provision ".kube", type: "shell", inline: <<-SCRIPT
    chown vagrant:vagrant /home/vagrant/.kube
    chown vagrant:vagrant /home/vagrant/.kube/config
    chmod 600 /home/vagrant/.kube/config
    sed -i 's,\\(cmd-path: \\)\\(.*gcloud.cmd\\),\\1/usr/lib/google-cloud-sdk/bin/gcloud,' /home/vagrant/.kube/config
  SCRIPT
  
  config.vm.provision "apt-get", type: "shell", inline: <<-SCRIPT
    apt-get update && apt-get install -y apt-transport-https
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list

    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

    apt-get update

    apt-get install -y \
      jq \
      kubectl \
      google-cloud-sdk
  SCRIPT
  
  config.vm.provision "ssh-keyscan", type: "shell", inline: <<-SCRIPT
    ssh-keyscan github.com >> /home/vagrant/.ssh/known_hosts
    ssh-keyscan bitbucket.com >> /home/vagrant/.ssh/known_hosts
  SCRIPT

  config.vm.provision "docker" do |d|
    d.run "socat",
      auto_assign_name: false,
      image: "bobrik/socat",
      args: "-d -v /var/run/docker.sock:/var/run/docker.sock -p 2375:2375",
      cmd: "TCP-LISTEN:2375,fork UNIX-CONNECT:/var/run/docker.sock"
  end
end
