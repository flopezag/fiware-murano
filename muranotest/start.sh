apt-get update
apt-get install -y curl host syslinux
host="murano"
ip="`gethostip -d "$host"`"
echo $ip
echo "$ip murano.lab.fiware.org" >> /etc/hosts
git fetch https://review.openstack.org/openstack/murano refs/changes/$REVISION && git checkout FETCH_HEAD
sed -i  '/^Route/d' /opt/murano/requirements.txt
echo 'Routes!=2.0,!=2.1,>=1.12.3' >> requirements.txt
pip install -r requirements.txt
pip install -r test-requirements.txt
python setup.py install
sed -i -e "s/XXX/${PASSWORD}/" /opt/murano/murano/tests/functional/engine/config.conf
sed -i -e "s/XXX/${PASSWORD}/" /opt/murano/murano/tests/functional/engine/config2.conf
sed -i -e "s/XXX/${PASSWORD}/" /opt/murano/murano/tests/functional/engine/config3.conf
sed -i -e "s/XXX/${PASSWORD}/" /opt/murano/murano/tests/functional/engine/config4.conf
sed -i -e "s/XXX/${PASSWORD}/" /etc/tempest/tempest.conf

while ! nc -z murano 8082; do sleep 8; done
export TEMPEST_CONFIG_DIR=/etc/tempest/
export TEMPEST_CONFIG=tempest.conf
cat /etc/tempest/tempest.conf
nosetests --with-xunit --xunit-file /opt/test2.xml murano.tests.functional.engine
cp /opt/murano/murano/tests/functional/engine/config2.conf /opt/murano/murano/tests/functional/engine/config.conf
nosetests --with-xunit --xunit-file /opt/test3.xml murano.tests.functional.engine
cp /opt/murano/murano/tests/functional/engine/config3.conf /opt/murano/murano/tests/functional/engine/config.conf
nosetests --with-xunit --xunit-file /opt/test4.xml murano.tests.functional.engine
cp /opt/murano/murano/tests/functional/engine/config4.conf /opt/murano/murano/tests/functional/engine/config.conf
nosetests --with-xunit --xunit-file /opt/test5.xml murano.tests.functional.engine
