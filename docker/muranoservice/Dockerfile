FROM ubuntu:16.04
RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y git murano-api murano-engine python-muranoclient
COPY murano.conf /etc/murano/murano.conf
COPY *.yaml /etc/murano/class-configs/
RUN mkdir /repo && cd /repo && git init && git remote add -f origin https://github.com/openstack/murano && git config core.sparseCheckout true && echo "meta/io.murano/" >> .git/info/sparse-checkout
&& git pull origin master
COPY start.sh /start.sh


EXPOSE 8082
CMD ./start.sh
 
