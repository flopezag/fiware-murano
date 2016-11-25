sed -i -e "s/RABBIT_HOST/${RABBIT_HOST}/" /etc/murano/class-configs/io.murano.Environment.yaml 
sed -i -e "s/RABBIT_PASSWORD/${RABBIT_PASSWORD}/" /etc/murano/class-configs/io.murano.Environment.yaml
sed -i -e "s/RABBIT_LOGIN/${RABBIT_LOGIN}/" /etc/murano/class-configs/io.murano.Environment.yaml
cat /etc/murano/class-configs/io.murano.Environment.yaml
sed -i -e "s/XXX/${PASSWORD}/" /opt/murano/etc/murano/murano.conf
git fetch https://review.openstack.org/openstack/murano refs/changes/$REVISION && git checkout FETCH_HEAD
cp -rf /opt/murano/meta2/* /opt/murano/meta
echo "MySQL-python" >> /opt/murano/test-requirements.txt
tox -e venv -- murano-db-manage \
  --config-file ./etc/murano/murano.conf upgrade
sed -i -e "s/'yaql.memoryQuota': 10000/'yaql.memoryQuota': 1000000/" .tox/venv/lib/python2.7/site-packages/yaql/cli/run.py
sed -i -e "s/'yaql.memoryQuota': 10000/'yaql.memoryQuota': 1000000/" .tox/venv/local/lib/python2.7/site-packages/yaql/cli/run.py
tox -e venv -- murano-api --config-file ./etc/murano/murano.conf &
while ! nc -z localhost 8082; do sleep 8; done
echo "  io.murano.resources.FiwareMuranoInstance: resources/FiwareMuranoInstance.yaml" >> meta/io.murano/manifest.yaml
cd  ./meta/io.murano
zip -r ../../io.murano.zip *
cd ./../../
tox -e venv -- murano --murano-url http://localhost:8082 --os-username admin --os-password $PASSWORD \
  --os-tenant-name admin --os-auth-url=http://cloud.lab.fi-ware.org:4730/v2.0 \
  package-import --exists-action u  --is-public io.murano.zip
sed -i -e "s/interface='admin'/interface='public'/" .tox/venv/lib/python2.7/site-packages/keystoneclient/httpclient.py
sed -i -e "s/ITERATORS_LIMIT = 2000/ITERATORS_LIMIT = 8000/" /opt/murano/murano/dsl/constants.py
sed -i -e "s/'yaql.memoryQuota': 10000/'yaql.memoryQuota': 1000000/" /opt/murano/.tox/venv/local/lib/python2.7/site-packages/yaql/cli/run.py
sed -i -e "s/'yaql.memoryQuota': 10000/'yaql.memoryQuota': 1000000/" /opt/murano/.tox/venv/lib/python2.7/site-packages/yaql/cli/run.py
tox -e venv -- murano-engine --config-file ./etc/murano/murano.conf
