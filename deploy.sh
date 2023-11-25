#!/bin/bash
if [ -d "/opt/flip" ]; then
    cd /opt/flip/config && git pull
    cd /opt/flip/www/ide && git pull 
    cd /opt/flip/www/flipbook && git pull 
    cd /opt/flip/www/ide && nvm use v19.1.0 && yarn theia start --hostname 0.0.0.0 --port 3000 & 

    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew services restart nginx 
    else 
        sudo service nginx restart
    fi 

    exit 0
fi


if [ $# -ne 1 ]; then
    echo "Usage: $0 <password>"
    exit 1
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    brew update && brew install git curl vim wget gcc libsecret make nginx gh
    sudo mkdir /opt/flip && chown "$USER:staff" /opt/flip
    sudo mkdir /opt/flip/www && chown "$USER:staff" /opt/flip/www
    sudo mkdir /opt/flip/www/home && chown "$USER:staff" /opt/flip/www/home
    cd /opt/flip && git clone https://github.com/michaelburgess-d/flip-www-config.git config
    cd /opt/flip/www && git clone https://github.com/michaelburgess-d/flip-ide-macos.git ide
    cd /opt/flip/www && git clone https://github.com/michaelburgess-d/flip-www-public.git flipbook

    cp /opt/flip/config/flip-nginx.config /opt/homebrew/etc/nginx/servers/
    sed -i "s/__PASSWORD__/$1/g" /opt/homebrew/etc/nginx/servers/flip-nginx.config
else
    sudo apt update && sudo apt install -y git curl vim wget gcc g++ pkg-config libsecret-1-dev make nginx gh
    sudo mkdir /opt/flip && chown "$USER:$USER" /opt/flip
    sudo mkdir /opt/flip/www && chown "www-data:www-data" /opt/flip/www
    sudo mkdir /opt/flip/www/home && chown "$USER:staff" /opt/flip/www/home
    cd /opt/flip && git clone https://github.com/michaelburgess-d/flip-www-config.git config
    cd /opt/flip/www && git clone https://github.com/michaelburgess-d/flip-ide-ubuntu-aws.git ide
    cd /opt/flip/www && git clone https://github.com/michaelburgess-d/flip-www-public.git flipbook
    
    cp /opt/flip/config/flip-nginx.config /etc/nginx/sites-enabled/default
    sed -i "s/__PASSWORD__/$1/g" /etc/nginx/sites-enabled/default
fi



curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

source "$HOME/.nvm/nvm.sh"
nvm install v19.1.0
npm install -g yarn

cd /opt/flip/www/ide && nvm use v19.1.0 && yarn theia start --hostname 0.0.0.0 --port 3000

# cd /opt/www/ide && yarn
# cd /opt/www/ide && yarn theia build