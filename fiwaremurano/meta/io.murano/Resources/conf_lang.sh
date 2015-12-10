#!/bin/bash

# Install Puppet
# Params:
#   $1: OS Distribution (RedHat, Debian)
#   $2: OS Revision
install_puppet () {
  dist=$1
  rev=$2

  echo "Installing Puppet for DIST $dist and REV $rev"

  if [ $dist == 'RedHat' ]; then
    if [[ $rev = "6" ]]; then
        rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
    fi
    if [[ $rev = "7" ]]; then
        rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
    fi
  fi

  if [ $dist == 'RedHat' ]; then
    yum install -y puppet
  else
    apt-get install -y puppet
  fi

  command -v puppet >/dev/null 2>&1 || { echo "I require puppet but it's not installed.  Aborting." >&2; exit 1; }
}

# Install Chef
install_chef() {
  echo "Installing Chef"
  curl -L https://www.opscode.com/chef/install.sh | bash
  command -v chef-solo >/dev/null 2>&1 || { echo "I require chef-solo but it's not installed.  Aborting." >&2; exit 1; }
}

# Install Docker
install_docker() {
  echo "Installing Docker"
  curl https://get.docker.com/ | bash
}

# Install FIWARE DEM Monitoring component
install_fiware_dem_monitoring(){
  echo "Installing FIWARE DEM Monitoring component"
  curl -L -s -k https://xifisvn.esl.eng.it/wp3/software/DEM_Adapter/install.sh | bash
}

# $DIST and $REV must be defined by murano-init.sh script

install_puppet $DIST $REV
install_chef
install_docker
install_fiware_dem_monitoring
