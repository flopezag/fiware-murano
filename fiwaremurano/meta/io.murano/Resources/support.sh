#!/bin/sh

region='%REGION%'

curl http://130.206.81.64:3000/v1/support/$region/gpgkey --output /etc/fiware-support/gpgbk.pub
curl http://130.206.81.64:3000/v1/support/$region/sshkey --output /etc/fiware-support/sshbk.pub

if [ -f "/etc/fiware-support/gpgbk.pub" ]
then
	cp /etc/fiware-support/gpgbk.pub /etc/fiware-support/defaultgpg.pub
else
    return
fi

if [ -f "/etc/fiware-support/sshbk.pub" ]
then
	cp /etc/fiware-support/sshbk.pub /etc/fiware-support/defaultssh.pub
else
    return
fi

while pidof /sbin/activate_support_account.py >> /dev/null ;
do
sleep 1
done


curl 'http://169.254.169.254/openstack/latest/meta_data.json' --output /etc/metadata.json

if [ ! -f "/etc/metadata.json" ]
then
    return
fi


if ! grep -Po '"uuid":.*?[^\\]",' /etc/metadata.json | grep `cat /etc/fiware-support/uuid`; then
   rm /etc/fiware-support/uuid
   /sbin/activate_support_account.py
else
  return
fi




