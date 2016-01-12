#!/bin/sh

same_uuid() {
  curl 'http://169.254.169.254/openstack/latest/meta_data.json' --output /etc/metadata.json
  if [ -f "/etc/metadata.json" ]
  then
    if grep -Po '"uuid":.*?[^\\]",' /etc/metadata.json | grep `cat /etc/fiware-support/uuid`; then
      echo "Same uuid"
      return 1
    fi
  fi
  echo "Different uuid VM"
  return 0
}

wait_process_finish() {
  while pidof /sbin/activate_support_account.py >> /dev/null ;
  do
    sleep 1
  done
}

reload() {
  echo "Reloading..."
  rm /etc/fiware-support/uuid
  /sbin/activate_support_account.py
}

region='%REGION%'

curl http://130.206.81.64:3000/v1/support/$region/gpgkey --output /etc/fiware-support/gpgbk.pub
curl http://130.206.81.64:3000/v1/support/$region/sshkey --output /etc/fiware-support/sshbk.pub

if [ -f "/etc/fiware-support/gpgbk.pub" ]
then
  cp /etc/fiware-support/gpgbk.pub /etc/fiware-support/defaultgpg.pub
else
  echo "Error no obtaining pgp key. Returning.."
  return
fi

if [ -f "/etc/fiware-support/sshbk.pub" ]
then
  cp /etc/fiware-support/sshbk.pub /etc/fiware-support/defaultssh.pub
else
  echo "Error no obtaining ssh key. Returning.."
  return
fi

if pidof /sbin/activate_support_account.py >> /dev/null
then
  sleep 1
  wait_process_finish
  reload
else
  if same_uuid==1; then
     reload
  fi
fi



