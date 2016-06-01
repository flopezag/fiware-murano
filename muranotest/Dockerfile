FROM ubuntu
RUN apt-get update && apt-get -y install python-pip python-dev \
  libmysqlclient-dev libpq-dev \
  libxml2-dev libxslt1-dev git \
  libffi-dev zip python-mysqldb netcat
RUN pip install tox; git clone https://github.com/openstack/murano /opt/murano/; git clone https://github.com/openstack/tempest /opt/murano/tempest
COPY config.conf /opt/murano/murano/tests/functional/engine/
COPY config2.conf /opt/murano/murano/tests/functional/engine/
COPY config3.conf /opt/murano/murano/tests/functional/engine/
COPY config4.conf /opt/murano/murano/tests/functional/engine/
WORKDIR /opt/murano/tempest
RUN pip install --upgrade pip
RUN pip install -r requirements.txt; pip install nose tempest-lib;  python setup.py install
WORKDIR /opt/murano
COPY start.sh /opt/murano/start.sh
COPY tempest.conf /etc/tempest/tempest.conf
CMD ./start.sh; nosetests --with-xunit --xunit-file /opt/test1.xml murano.tests.functional.api.v1
