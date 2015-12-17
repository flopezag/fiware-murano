#!/bin/sh

ps cax | grep muranoagent > /dev/null
if [ $? -eq 0 ]; then
  echo "murano-agent service exists"
else
  muranoAgentConf='%MURANO_AGENT_CONF%'
  echo $muranoAgentConf | base64 -d > /etc/init/murano-agent.conf
  muranoAgentService='%MURANO_AGENT_SERVICE%'
  echo $muranoAgentService | base64 -d > /etc/systemd/system/murano-agent.service
  muranoAgent='%MURANO_AGENT%'
  echo $muranoAgent | base64 -d > /etc/init.d/murano-agent
  chmod +x /etc/init.d/murano-agent
  PYTHON_VERSION=`python -c 'import sys; print(".".join(map(str, sys.version_info[:3])))'`
  if [[ $PYTHON_VERSION == "2.6"* ]]
  then
    yum groupinstall "Development tools"
    yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
    wget http://python.org/ftp/python/2.7.6/Python-2.7.6.tar.xz
    tar xf Python-2.7.6.tar.xz
    cd Python-2.7.6
    ./configure --prefix=/usr/local --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
    make && make altinstall
    wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py

    # Then install it for Python 2.7 and/or Python 3.3:
    /usr/local/bin/python2.7 ez_setup.py
    /usr/local/bin/easy_install-2.7 pip
    /usr/local/bin/pip2.7 install git+https://github.com/openstack/murano-agent
    cp /usr/local/bin/muranoagent /usr/bin/muranoagent
  else
    pip install git+https://github.com/openstack/murano-agent
  fi
fi


install python6




