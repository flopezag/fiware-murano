apt-get install -y curl host syslinux
host="murano"
ip="`gethostip -d "$host"`"
echo $ip
echo "$ip murano.lab.fiware.org" >> /etc/hosts
git fetch https://review.openstack.org/openstack/murano refs/changes/$REVISION && git checkout FETCH_HEAD
sed -i -e "s/XXX/${PASSWORD}/" /opt/murano/murano/tests/functional/engine/config.conf
sed -i -e "s/XXX/${PASSWORD}/" /etc/tempest/tempest.conf
while ! nc -z murano 8082; do sleep 8; done
