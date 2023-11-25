sudo apt update && sudo apt install -y git curl vim wget nginx gh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
sudo mkdir /svr/www && chown www-data:www-data /srv/www
cd /srv/www && git clone https://github.com/michaelburgess-d/ide.git 
cd /srv/www && git clone https://github.com/michaelburgess-d/flip.git 
bash ~/.bashrc && ~/.nvm/nvm.sh 
nvm install v19.1.0 && npm install -g yarn  
cd /srv/www/ide && nvm use v19.1.0 && yarn theia start --hostname 0.0.0.0
