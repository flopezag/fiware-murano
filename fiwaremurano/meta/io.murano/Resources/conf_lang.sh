#!/bin/bash

obtain_os_information () {
  OS=$(uname -s)
  REV=$(uname -r)

  if [ "${OS}" = "Linux" ] ; then
    if [ -f /etc/redhat-release ] ; then
        DIST='RedHat'
        REV=$(cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//)
    elif [ -f /etc/debian_version ] ; then
        DIST="Debian"
        REV=$(cat /etc/debian_version)
    else
        echo "Linux Distribution not valid for installing murano-agent"
        exit
    fi
    REV=$(echo ${REV} | cut -d. -f1)
  else
     echo "OS no valid for installing murano-agent"
     exit
  fi
}

install_puppet () {
  obtain_os_information
  if [ $DIST == 'RedHat' ]; then
    if [[ ${REV} = "6" ]]; then
        rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
    fi
    if [[ ${REV} = "7" ]]; then
        rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
    fi
  fi

  if [ ${DIST} == 'RedHat' ]; then
    yum install -y puppet
  else
    apt-get install -y puppet
  fi

  command -v puppet >/dev/null 2>&1 || { echo "I require puppet but it's not installed.  Aborting." >&2; exit 1; }
}

install_chef() {
  curl -L https://www.opscode.com/chef/install.sh | bash
  curl https://get.docker.com/ | bash
  command -v chef-solo >/dev/null 2>&1 || { echo "I require chef-solo but it's not installed.  Aborting." >&2; exit 1; }
}

install_puppet
install_chef
