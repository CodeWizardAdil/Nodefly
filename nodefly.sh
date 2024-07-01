#!/bin/bash

# Define color codes for easier printing
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color


echo "b.             8     ,o888888o.     8 888888888o.      8 8888888888   8 8888888888   8 8888  \`8.\`8888.      ,8' "
echo "888o.          8  . 8888     \`88.   8 8888    \`^888.   8 8888         8 8888         8 8888   \`8.\`8888.    ,8'  "
echo "Y88888o.       8 ,8 8888       \`8b  8 8888        \`88. 8 8888         8 8888         8 8888    \`8.\`8888.  ,8'   "
echo ".\`Y888888o.    8 88 8888        \`8b 8 8888         \`88 8 8888         8 8888         8 8888     \`8.\`8888.,8'    "
echo "8o. \`Y888888o. 8 88 8888         88 8 8888          88 8 888888888888 8 888888888888 8 8888      \`8.\`88888'     "
echo "8\`Y8o. \`Y88888o8 88 8888         88 8 8888          88 8 8888         8 8888         8 8888       \`8. 8888      "
echo "8   \`Y8o. \`Y8888 88 8888        ,8P 8 8888         ,88 8 8888         8 8888         8 8888        \`8 8888      "
echo "8      \`Y8o. \`Y8 \`8 8888       ,8P  8 8888        ,88' 8 8888         8 8888         8 8888         8 8888      "
echo "8         \`Y8o.\`  \` 8888     ,88'   8 8888    ,o88P'   8 8888         8 8888         8 8888         8 8888      "
echo "8            \`Yo     \`8888888P'     8 888888888P'      8 888888888888 8 8888         8 888888888888 8 8888      "

echo -e "${BLUE}-- by CodeWizardAdil${NC}"
echo -e "(https://x.com/adil_emmi)"
echo -e "(https://medium.com/@xUr00U)"

echo -e "${RED}Updating Server${NC}"
sudo apt update -y && sudo apt upgrade -y
echo -e "${RED}Installing NVM${NC}"
command -v nvm >/dev/null 2>&1 || { curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash; }
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


source ~/.bashrc  

nvm --version

echo -e "${RED}Installing System Dependencies${NC}"
sudo apt install -y python3-pip nginx
sudo snap install core
sudo apt remove -y certbot
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

echo -e "${RED}Generating RSA Key :${NC}"
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N "" -q


public_key=$(cat ~/.ssh/id_rsa.pub)
echo -e "${RED}Your SSH Deployment key is :${NC}"
echo -e "${YELLOW}$public_key${NC}"

echo -e "${BLUE}Enter Domain Name (e.g., example.com): ${NC}"
read -r domain_name1

echo -e "${BLUE}Enter Domain Name (e.g., www.example.com): ${NC}"
read -r domain_name2

echo -e "${BLUE}Enter the port number your application runs on localhost (e.g., 3000): ${NC}"
read -r app_port

echo -e "${BLUE}Enter GitHub Repo SSH URL (e.g., git@github.com:user/repo.git): ${NC}"
read -r github_repo_ssh_url

echo -e "${BLUE}Enter Server file name :(e.g., index.js) ${NC}"
read -r js_file

echo -e "${RED}Setting up firewall${NC}"
sudo ufw allow ssh 
sudo ufw allow http
sudo ufw allow https
sudo ufw allow $app_port

update_nginx_config() {
    local domain=$1
    local domain2=$2
    local nginx_conf_file="/etc/nginx/sites-available/default"

    sudo chown $USER:$USER $nginx_conf_file

    local nginx_conf_template=$(cat <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    server_name $domain $domain2;

    location / {
        proxy_pass http://localhost:$app_port; #whatever port your app runs on
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF
)
    # Write the updated configuration to the file
    echo "$nginx_conf_template" | sudo tee $nginx_conf_file

    # Restart Nginx to apply changes
    sudo nginx -t && sudo systemctl reload nginx
    echo "Nginx configuration updated with server_name $domain"
}


node_project_dir="$HOME/Node-project"


if [ -d "$node_project_dir" ]; then
    echo "Directory $node_project_dir already exists. Removing existing content..."
    rm -rf "$node_project_dir"
fi


mkdir -p "$node_project_dir"

git clone "$github_repo_ssh_url" "$node_project_dir"

if [ -d "$node_project_dir/node_modules" ]; then
  rm -rf "$node_project_dir/node_modules"
fi

echo "Repository cloned into $node_project_dir: $github_repo_ssh_url"

echo -e "${RED}Installing Node & Npm${NC}"
nvm install --lts
sudo ln -s "$NVM_DIR/versions/node/$(nvm version)/bin/node" "/usr/local/bin/node"
sudo ln -s "$NVM_DIR/versions/node/$(nvm version)/bin/npm" "/usr/local/bin/npm"

cd $node_project_dir
echo -e "${RED}Setup .env file${NC}"
nano .env
echo -e "${RED}Installing Node.js dependencies${NC}"
npm install express
npm install
npm uninstall bcrypt
sudo npm i bcrypt

echo -e "${RED}Node.js dependencies installed successfully.${NC}"

echo -e "${RED}Installing PM2${NC}"

npm install pm2 -g

echo -e "${RED}PM2 Installed Succesfully${NC}"

echo -e "${RED}Starting Node.js application '$js_file' with PM2${NC}"

pm2 start $js_file --name my-node-app --watch --ignore-watch="node_modules"

echo "Node.js application '$js_file' started successfully with PM2."

pm2 save
pm2 startup

echo -e "${RED}Configuring Nginx${NC}"

update_nginx_config $domain_name1 $domain_name2

echo -e "${RED}Obtaining an FREE SSL Certificate${NC}"

sudo certbot --nginx -d $domain_name1 $domain_name2 

echo -e "${GREEN}Hola! Your application is hosted on https://$domain_name2. Thanks for using NodeFly.${NC}"
