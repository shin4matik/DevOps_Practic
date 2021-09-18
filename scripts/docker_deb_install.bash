#!/usr/bin/bash
#######################################  
# Bash script to install latest version of Docker & Docker Compose
# by Debian WAY ;)
# Author:   Volodymyr Borys
   
clear

# Color Reset
Color_Off='\033[0m'       # Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan

update() {
	# Update system repos
	echo -e "\n ${Cyan} Updating repositories.. ${Color_Off}"
	sudo apt-get update -q
}

removeDocker(){
	echo -e "\n ${Red} Remove old versions.. ${Color_Off}"
	sudo apt-get remove docker docker-engine docker.io containerd runc -yy
}

installDep() {
	echo -e "\n ${Green} Install dependencies.. ${Color_Off}"
	sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -yy
}

addRepo() {
	echo -e "\n ${Yellow} Add repositories.. ${Color_Off}"
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	echo   "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
	$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
}

installDocker() {
	echo -e "\n ${Green} Installing Docker.. ${Color_Off}"
	sudo apt-get install docker-ce docker-ce-cli containerd.io -yy
}

addGroup() {
	echo -e "\n ${Yellow} Include user to docker group.. ${Color_Off}"
	sudo groupadd docker
	sudo usermod -aG docker $USER
	newgrp docker
}

enableIt() {
	echo -e "\n ${Yellow} Enable services.. ${Color_Off}"
	sudo systemctl enable docker.service
	sudo systemctl enable containerd.service

}

composeInstall() {
	echo -e "\n ${Green} Installing docker-compose.. ${Color_Off}"
	sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	docker-compose --version

}



# RUN
update
removeDocker
installDep
addRepo
update
installDocker
#addGroup
enableIt
composeInstall
