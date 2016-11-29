FROM ubuntu:16.04
RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y git zip murano-api murano-engine python-muranoclient
COPY murano.conf /etc/murano/murano.conf
COPY *.yaml /etc/murano/class-configs/
RUN mkdir /repo && cd /repo && git init && git remote add -f origin https://github.com/openstack/murano && git config core.sparseCheckout true && echo "meta/io.murano/" >> .git/info/sparse-checkout && git pull origin stable/mitaka
RUN mkdir /repo2 && cd /repo2 && git init && git remote add -f origin https://github.com/telefonicaid/fiware-murano  && git config core.sparseCheckout true && echo "docker/meta/io.murano/" >> .git/info/sparse-checkout && git pull origin master
RUN cp -rf /repo2/docker/* /repo
RUN cd  /repo/meta/io.murano && zip -r ../../io.murano.zip * && cd ./../../
RUN echo "  io.murano.resources.FiwareMuranoInstance: resources/FiwareMuranoInstance.yaml" >> /repo/meta/io.murano/manifest.yaml 
COPY start.sh /start.sh
EXPOSE 8082
CMD ./start.sh
 
