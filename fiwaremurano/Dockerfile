FROM ubuntu
RUN apt-get update && sudo apt-get -y install python-pip python-dev \
  libmysqlclient-dev libpq-dev \
  libxml2-dev libxslt1-dev git \
  libffi-dev zip python-mysqldb mysql-server
RUN pip install -I pip==7.1.2
RUN pip install tox
RUN git clone https://github.com/openstack/murano /opt/murano/
WORKDIR /opt/murano
COPY murano.conf /opt/murano/etc/murano/murano.conf
COPY start.sh /opt/murano/start.sh
EXPOSE 8082
COPY meta /opt/murano/meta2
CMD ./start.sh
