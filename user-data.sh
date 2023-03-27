#!/bin/bash

# Change 'admin' to 'ec2-user' for RHEL/CentOS/AmazonLinux 
RUNAS="sudo -u admin"

# Make bigger swap
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# The bear necessities
sudo apt update && sudo apt install -y curl htop wget vim-nox python3 python3-pip tmux git jq unzip gnupg software-properties-common

# Python plugins
$RUNAS /usr/bin/python3 -m pip install yapf cookiecutter

# Rust
$RUNAS /usr/bin/curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | $RUNAS sh -s -- -y --no-modify-path
echo 'source "$HOME/.cargo/env"' >> /home/admin/.bashrc

# AWS Cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
cd /tmp && unzip awscliv2.zip && sudo ./aws/install && cd

# Vim Plugins
$RUNAS git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt-get install -y terraform

# New Relic
curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash

# Oh-my-bash
export OSH_THEME="powerline"'
$RUNAS bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
