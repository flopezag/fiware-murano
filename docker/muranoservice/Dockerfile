FROM ubuntu:16.04
RUN apt-get update && apt-get install -y software-properties-common && add-apt-repository cloud-archive:newton
RUN apt-get update && apt-get -y dist-upgrade && DEBIAN_FRONTEND=noninteractive apt-get install -y git netcat murano-api murano-engine python-muranoclient
COPY murano.conf /etc/murano/murano.conf
COPY *.yaml /etc/murano/class-configs/
RUN mkdir /murano && cd /murano && git init && git remote add -f origin https://github.com/openstack/murano && git config core.sparseCheckout true && echo "meta/io.murano/" >> .git/info/sparse-checkout && git pull origin stable/newton
RUN mkdir /fiware-murano && cd /fiware-murano && git init && git remote add -f origin https://github.com/telefonicaid/fiware-murano  && git config core.sparseCheckout true && echo "docker/meta/io.murano/" >> .git/info/sparse-checkout && git pull origin develop
RUN cp -rf /fiware-murano/docker/* /murano
RUN echo "  io.murano.resources.FiwareMuranoInstance: resources/FiwareMuranoInstance.yaml" >> /murano/meta/io.murano/manifest.yaml 
COPY start.sh /start.sh
EXPOSE 8082
CMD ./start.sh
 
