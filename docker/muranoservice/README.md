# Installing murano as service
## Install murano packages

    apt-get install murano-api murano-engine python-muranoclient

## Create database

To create the database, complete these steps:

Use the database access client to connect to the database server as the root user:

    $ mysql -u root -p

Create the murano database:

    CREATE DATABASE murano;

Grant proper access to the heat database:

    GRANT ALL PRIVILEGES ON murano.* TO 'murano'@'localhost' \
    IDENTIFIED BY 'MURANO_DBPASS';

    GRANT ALL PRIVILEGES ON murano.* TO 'murano'@'%' \
    IDENTIFIED BY 'MURANO_DBPASS';

Replace MURANO_DBPASS with a suitable password.

Exit the database access client.

## Create endpoints

Create the application-catalog service API endpoints:

    $ keystone service-create --name application-catalog --type application-catalog \
     --description "application-catalog"

    $ keystone endpoint-create \
     --service-id $(keystone service-list | awk '/ application-catalog / {print $2}') \
     --publicurl http://controller:8082/v1/%\(tenant_id\)s \
     --internalurl http://controller:8082/v1/%\(tenant_id\)s \
     --adminurl http://controller:8082/v1/%\(tenant_id\)s \
     --region regionOne

## Configure murano
Edit the /etc/murano/murano.conf file and complete the following actions:

In the [database] section, configure database access:

    [database]
    ...
    connection = mysql://murano:MURANO_DBPASS@controller/murano

Replace MURANO_DBPASS with the password you chose for the Murano database.

In the [DEFAULT] section, configure RabbitMQ message broker access:

    [DEFAULT]
    ...
    rpc_backend = rabbit
    rabbit_host = controller
    rabbit_password = RABBIT_PASS

Replace RABBIT_PASS with the password you chose for the guest account in RabbitMQ.

In the [keystone_authtoken] and [ec2authtoken] sections, configure Identity service access:

    [keystone_authtoken]
    ...
    auth_uri = http://controller:5000/v2.0
    identity_uri = http://controller:35357
    admin_tenant_name = service
    admin_user = murano
    admin_password = MURANO_PASS

    [ec2authtoken]
    ...
    auth_uri = http://controller:5000/v2.0
    Replace MURANO_PASS with the password you chose for the heat user in the Identity service.

In the murano section, it is required to specified the default region in a multiregion environment

    [murano]

    region_name_for_services = RegionOne

In the engine section, the folder where to configure classes required for [multiregion](http://docs.openstack.org/developer/murano/articles/multi_region.html).

    [engine]

    class_configs = /etc/murano/class-configs

In this folder, it is possible to specify a file for managing multi-region as io.murano.Environment.yaml, which the content

    regionConfigs:
    Spain2:
        agentRabbitMq:
        host: RABBIT_HOST
        login: RABBIT_LOGIN
        password: RABBIT_PASSWORD


In the networking section, specify the public network and router to be used.
    [networking]
    ...
    external_network = public-ext-net-01 (the public network)
    router_name = rt2-external (the router name to be created)

In the rabbitmq section [rabbitmq], which represents the rabbit among murano-engine and virtual machines

    [rabbitmq]
    ...
    host =130.206.84.6 (the rabbitmq host)
    login = guest (The RabbitMQ login.)
    password = guest (The RabbitMQ password)

### Populate the murano database

Use the following command:

    murano-db-manage upgrade

### Import core library.
It is required to obtain the core library which is in [murano repository](https://github.com/openstack/murano/tree/master/meta/io.murano)
We need to execute the zip file for that folder and import in murano by:

    murano package-import --exists-action u  --is-public io.murano.zip

### Import packages


