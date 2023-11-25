#!/bin/bash
if [ -d "/opt/flip" ]; then
    cd /opt/www/ide && nvm use v19.1.0 && yarn theia start --hostname 0.0.0.0 --port 3000
fi



curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

if [[ "$OSTYPE" == "darwin"* ]]; then
    brew update && brew install git curl vim wget gcc libsecret make nginx gh
    sudo mkdir /opt/flip && chown "$USER:staff" /opt/flip
    sudo mkdir /opt/flip/www && chown "$USER:staff" /opt/flip/www
    sudo mkdir /opt/flip/www/home && chown "$USER:staff" /opt/flip/www/home
    cd /opt/flip && git clone https://github.com/michaelburgess-d/flip-ide-macos.git ide
else
    sudo apt update && sudo apt install -y git curl vim wget gcc g++ pkg-config libsecret-1-dev make nginx gh
    sudo mkdir /opt/flip && chown "$USER:$USER" /opt/flip
    sudo mkdir /opt/flip/www && chown "www-data:www-data" /opt/flip/www
    sudo mkdir /opt/flip/www/home && chown "$USER:staff" /opt/flip/www/home
    cd /opt/flip/www && git clone https://github.com/michaelburgess-d/flip-ide-ubuntu-aws.git ide
    cd /opt/flip/www && git clone https://github.com/michaelburgess-d/flip-public.git flipbook
fi

if [ -s "$HOME/.nvm/nvm.sh" ]; then
    source "$HOME/.nvm/nvm.sh"
fi

nvm install v19.1.0
npm install -g yarn
cd /opt/www/ide && nvm use v19.1.0 && yarn theia start --hostname 0.0.0.0 --port 3000

# cd /opt/www/ide && yarn
# cd /opt/www/ide && yarn theia build