Vagrant.configure("2") do |config|
  config.vm.define "devbox"
  config.vm.box = "ubuntu/impish64"
  config.vm.network "private_network", ip: "192.168.50.5"
  config.disksize.size = "100GB"

  config.vm.provider "virtualbox" do |v|
    v.name = "devbox"
    v.gui = false
    v.memory = 8192
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

  config.vm.provision ".gitconfig", type: "shell", inline: <<-SCRIPT
    git config --global core.autocrlf false
    git config --global alias.lola 'log --graph --decorate --pretty=oneline --abbrev-commit --all'
  SCRIPT
  
  config.vm.provision ".kube", type: "shell", inline: <<-SCRIPT
    chown vagrant:vagrant /home/vagrant/.kube
    chown vagrant:vagrant /home/vagrant/.kube/config
    chmod 600 /home/vagrant/.kube/config
    sed -i 's,\\(cmd-path: \\)\\(.*gcloud.cmd\\),\\1/usr/lib/google-cloud-sdk/bin/gcloud,' /home/vagrant/.kube/config
  SCRIPT
  
  config.vm.provision "apt-get", type: "shell", inline: <<-SCRIPT
    apt-get update
    apt-get upgrade
    apt-get install -y \
      apt-transport-https \
      ca-certificates \
      gnupg \
      curl
      
    curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

    apt-get update

    apt-get install -y \
      jq \
      kubectl \
      google-cloud-sdk \
      google-cloud-cli \
      nodejs \
      npm \
      dotnet-sdk-6.0

    npm install -g funny-bunny
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
