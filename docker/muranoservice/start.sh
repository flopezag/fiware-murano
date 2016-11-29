apt-get install -y netcat curl host syslinux-utils
while ! nc -z mysql 3306; do sleep 8; done
sed -i -e "s/RABBIT_HOST/${RABBIT_HOST}/" /etc/murano/class-configs/io.murano.Environment.yaml 
sed -i -e "s/RABBIT_PASSWORD/${RABBIT_PASSWORD}/" /etc/murano/class-configs/io.murano.Environment.yaml
sed -i -e "s/RABBIT_LOGIN/${RABBIT_LOGIN}/" /etc/murano/class-configs/io.murano.Environment.yaml
sed -i -e "s/XXX/${PASSWORD}/" /etc/murano/murano.conf
murano-db-manage upgrade
service murano-api restart
murano package-import --exists-action u  --is-public /repo/io.murano.zip
service murano-engine stop
service murano-engine start
sleep 120000
