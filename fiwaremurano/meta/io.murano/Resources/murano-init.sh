#!/bin/bash

set -eu

# Get OS information.
# Return:
#   $DIST: OS Distribution (RedHat, Debian)
#   $REV: OS Revision
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

name=murano-agent
svc_root=${DIB_MURANO_AGENT_SVC_ROOT:-/opt/stack/$name}
install_dir=${DIB_MURANO_AGENT_INSTALL_DIR:-/opt/stack/venvs/$name}
repo=${DIB_MURANO_AGENT_REPO:-git://git.openstack.org/openstack/murano-agent.git}
branch=${DIB_MURANO_AGENT_BRANCH:-master}
ref=${DIB_MURANO_AGENT_REF:-''}

# Get OS Information. Set $DIST and $REV with suitable values.
obtain_os_information
echo "OS Information (by murano-init.sh)"
echo "  > OS: $OS"
echo "  > Distribution: $DIST"
echo "  > Revision: $REV"

# Install base packages
if [ $DIST == 'RedHat' ]; then
    if [ $REV = "6" ]; then
        rpm -ivh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
    else
        rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
    fi

    yum -y install subversion git-core wget make gcc python-pip python-dev python-setuptools python-virtualenv
else
    apt-get update
    apt-get install -y subversion git-core wget make gcc python-pip python-dev python-setuptools python-virtualenv
fi

# clone murano-agent source code into /opt/stack/murano-agent
mkdir -p $svc_root
git clone --depth=1 -b $branch $repo $svc_root
if [ -n "$ref" ]; then
    pushd $svc_root
    git fetch $repo $ref && git checkout FETCH_HEAD
    popd
fi

# install murano-agent into virtualenv at /ops/stack/venvs/murano-agent
virtualenv $install_dir
$install_dir/bin/pip install $svc_root

# setup config file at /etc/murano/agent.conf
mkdir -p /etc/murano

pushd ${svc_root}
${install_dir}/bin/oslo-config-generator --config-file ${svc_root}/etc/oslo-config-generator/muranoagent.conf
popd

cp ${svc_root}/etc/muranoagent/muranoagent.conf.sample /etc/murano/agent.conf.sample

dir_folder=${svc_root}/contrib/elements/murano-agent/install.d/
# install upstart script for murano-agent
if [ -d "/etc/init/" ]; then
    install -D -g root -o root -m 0755 ${dir_folder}/murano-agent.conf /etc/init/
fi
if [ -d "/etc/systemd/system/" ]; then
    install -D -g root -o root -m 0755 ${dir_folder}/murano-agent.service /etc/systemd/system/
fi

if [ $DIST == 'RedHat' ]; then
    if [[ $REV = "6" ]]; then
     cd /etc/init.d

wget http://repositories.testbed.fi-ware.org/webdav/murano-agent

chmod 777 murano-agent
   fi
fi
service murano-agent start
