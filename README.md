# vagrant-devbox

## Prerequisites

- Oracle VirtualBox
- Vagrant
- Vagrant plugin: [disksize](https://github.com/sprotheroe/vagrant-disksize)

## Features

- Copy config (git, ssh, k8s) from host
- Installs:
  - nodejs 16
  - dotnet 6.0
  - gcloud
  - kubectl
  - funny-bunny (for RabbitMQ)
- Docker (+ docker.sock over TCP port 2375)