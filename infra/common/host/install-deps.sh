#!/bin/bash
#
# Docker and nvm/node install script
# Jon Ribeiro <contact@jonathas.com>
#

if [ `whoami` != 'root' ];then
	echo 'This needs to be run as root'
	exit 1
fi

# Kernel has to be at least 3.18 for us to be able to use Docker with overlay driver
if [[ `uname -r` = *"3.16.0"* ]]
then
  echo 'Please run the update-kernel.sh script before running this script'
  exit 1
fi

if ! id "jon" >/dev/null 2>&1; then
    useradd -ms /bin/bash jon
fi

# Load overlay module
modprobe overlay

# Install Docker - https://docs.docker.com/engine/installation/linux/debian/
apt-get update && apt-get install apt-transport-https ca-certificates gnupg2 curl -y
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list
apt-get update && apt-get install docker-engine -y

# Start docker using the overlay module
dockerConfigDir="/etc/systemd/system/docker.service.d"
mkdir -p $dockerConfigDir
# drop-in file - https://www.freedesktop.org/software/systemd/man/systemd.unit.html
# This way, when docker-engine is updated, we don't lose the storage driver option, as it's not being passed in the service file anymore
echo -en "[Service]\nExecStart=\nExecStart=/usr/bin/docker daemon -H fd:// --storage-driver=overlay\n\n" > $dockerConfigDir/docker.conf

systemctl daemon-reload

systemctl start docker
systemctl enable docker

gpasswd -a jon docker

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install Node via nvm
NODE_VERSION='8.8.1'
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.0/install.sh | NVM_DIR=/usr/local/nvm PROFILE=/etc/bash.bashrc bash
export NVM_DIR="/usr/local/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install $NODE_VERSION && npm i -g gulp && ln -s /usr/local/nvm/versions/node/v${NODE_VERSION}/lib/node_modules/gulp/bin/gulp.js /usr/bin/gulp
ln -s /usr/local/nvm/versions/node/v${NODE_VERSION}/bin/node /usr/bin/node
ln -s /usr/local/nvm/versions/node/v${$NODE_VERSION}/bin/npm /usr/bin/npm

export PATH="/usr/local/nvm/versions/node/v${$NODE_VERSION}/bin:${PATH}"

# Install yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb http://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
apt-get update && apt-get install yarn -y
