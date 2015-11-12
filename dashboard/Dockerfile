FROM ubuntu
#murano-dashboard+horizon installation
RUN apt-get update && sudo apt-get -y install python-pip python-dev \
  libmysqlclient-dev libpq-dev \
  libxml2-dev libxslt1-dev git \
  libffi-dev zip python-mysqldb mysql-server
RUN pip install tox

RUN mkdir /opt/murano-dashboard
RUN git clone git://git.openstack.org/openstack/murano-dashboard /opt/murano-dashboard
RUN cd /opt/murano-dashboard; git checkout stable/kilo
RUN mkdir /opt/horizon
RUN git clone git://git.openstack.org/openstack/horizon /opt/horizon
RUN cd /opt/horizon; git checkout stable/kilo
WORKDIR /opt/horizon

RUN tox -e venv -- pip install -e ../murano-dashboard
RUN cp /opt/murano-dashboard/muranodashboard/local/_50_murano.py /opt/horizon/openstack_dashboard/local/enabled/
# RUN cp openstack_dashboard/local/local_settings.py.example openstack_dashboard/local/local_settings.py
# config file
COPY local_settings.py /opt/horizon/openstack_dashboard/local/
RUN tox -e venv -- python manage.py syncdb --noinput
COPY base.py /opt/base.py
RUN cp /opt/base.py .tox/venv/lib/python2.7/site-packages/keystoneclient/auth/identity/base.py
EXPOSE 8000
CMD export WEBIP=`ip route get 8.8.8.8 | awk '{print $NF; exit}'`; tox -e venv -- python manage.py runserver $WEBIP:8000
