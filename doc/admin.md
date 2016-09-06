
# Installation and Administration Guide

## Introduction

This guide defines the procedure to install the different components that build
up the FIWARE Murano GE,

For general information, please refer to GitHub's [README](https://github.com/telefonicaid/fiware-murano/blob/master/README.md).

## Installing OpenStack Murano

If you planned to install Murano from the OpenStack you can follow the oficial
[OpenStack Murano Installation Guide](http://murano.readthedocs.io/en/stable-liberty/install/index.html)


## Installing FIWARE Murano specific requirements

In addition to the oficial Murano documentation, to be FIWARE Murano aware, we need to install some extensions to Murano core library.
It involves mainly the addition of:

-   the FiwareMuranoInstance instance: this is a Murano instance which includes the region and the GE NID (in case required) in the deployed VMs. This is
 required for FIWARE monitoring.
-   the script key: There is a support script which includes a support key to be used by region administrators to give support to users.
-   the murano agent configuration file: It includes different murano-agent configuration files for services to be included in the different
  linux distributions.

To add the new information, wee need to copy it into the murano official meta folder.  We assume that {murano_folder} is the folder where
Openstack murano has been deployed

    $ git clone https://github.com/telefonicaid/fiware-murano {murano_folder}
    $ cp -rf /opt/fiware-murano/meta {murano_folder}

Also we need to add the FIWAREMuranoInstance to the manifest core library.

    $ echo "  io.murano.resources.FiwareMuranoInstance: resources/FiwareMuranoInstance.yaml" >> meta/io.murano/manifest.yaml

We create a zip file

    $ cd  {murano_folder}/meta/io.murano
    $ zip -r ../../io.murano.zip *
    $ cd ./../../

Finally, we execute the commando package-import for the murano client library (cosidering we are configuring Murano agains FIWARE Lab)

    $ tox -e venv -- murano --murano-url http://localhost:8082 --os-username admin --os-password $PASSWORD \
    --os-tenant-name admin --os-auth-url=http://cloud.lab.fi-ware.org:4730/v2.0 \
    package-import --exists-action u  --is-public io.murano.zip

It will update the Murano core library with the new FIWARE extensions.

## Sanity check procedures

The Sanity Check Procedures are the steps that a System Administrator
will take to verify that an installation is ready to be tested. This is
therefore a preliminary set of tests to ensure that obvious or basic
malfunctioning is fixed before proceeding to unit tests, integration
tests and user validation.

### End to End testing

Although one End to End testing must be associated to the Integration
Test, we can show here a quick testing to check that everything is up
and running. For this purpose we send a request to our API in order to
test the credentials that we have from then and obtain a valid token to
work with.

In order to make a probe of the different functionalities related to the
Murano, we start with the obtention of a valid token for a
registered user. Due to all operations of the Murano are using
the security mechanism which is used in the rest of the cloud component,
it is needed to provide a security token in order to continue with the
rest of operations. For this operation we need to execute the following
curl sentence.

    curl -d '{"auth": {"tenantName": $TENANT,
    "passwordCredentials":{"username": $USERNAME, "password": $PASSWORD}}}'
    -H "Content-type: application/json" -H "Accept: application/xml"
    http://$KEYSTONE_IP:$KEYSTONE_PORT/v2.0/tokens

Both $TENANT (Project), $USERNAME and $PASSWORD must be values
previously created in the OpenStack Keystone. The $KEYSTONE_IP and $KEYSTONE_PORT are the data of our internal
installation of IdM (Keystone).

We obtained two data from the previous sentence:

-  X-Auth-Token

    <token expires="2012-10-25T16:35:42Z" id="a9a861db6276414094bc1567f664084d">

-  Tenant-Id

    <tenant enabled="true" id="c907498615b7456a9513500fe24101e0" name=$TENANT>

After it, we can check if Murano is up and running with a
single instruction which is used to return the information of the status
of the processes together with the queue size.

    curl -v -H 'X-Auth-Token: a9a861db6276414094bc1567f664084d'
    -X GET http://murano.lab.fiware.org:8082

This operation will return the information regarding the tenant details
of the execution of the Policy Manager

    < HTTP/1.0 200 OK
    < Date: Wed, 09 Apr 2014 08:25:17 GMT
    < Server: WSGIServer/0.1 Python/2.6.6
    < Content-Type: text/html; charset=utf-8
    {
       "versions":
       [
           {
               "status": "CURRENT",
               "id": "v1.0",
               "links":
               [
                   {
                       "href": "http://murano.lab.fiware.org:8082/v1/",
                       "rel": "self"
                   }
               ]
           }
       ]
    }


For more details to use this GE, please refer to the User & Programmers Guide.

### List of Running Processes

Due to the Murano basically is running over the python process by using tox,
the list of processes must be only tox process for murano-api and murano-engine:

    ps -ewf | grep 'tox' | grep -v grep

It should show something similar to the following:


    UID        PID  PPID  C STIME TTY          TIME CMD
    root       739     5  0 10:50 ?        00:00:00 /usr/bin/python /usr/local/bin/tox -e venv -- murano-api --config-file ./etc/murano/murano.conf
    root       762   739  0 10:50 ?        00:00:02 /opt/murano/.tox/venv/bin/python .tox/venv/bin/murano-api --config-file etc/murano/murano.conf
    root       800     5  0 10:50 ?        00:00:00 /usr/bin/python /usr/local/bin/tox -e venv -- murano-engine --config-file ./etc/murano/murano.conf
    root       821   800  0 10:50 ?        00:00:02 /opt/murano/.tox/venv/bin/python .tox/venv/bin/murano-engine --config-file etc/murano/murano.conf

In addition, mysql and rabbitmq process should be exist (or in the same server or in another one, according to configuration).


    UID        PID  PPID  C STIME TTY          TIME CMD
    mysql        1     0  0 10:47 ?        00:00:00 mysqld

    rabbitmq     1     0  0 10:47 ?        00:00:00 /bin/sh -e /usr/lib/rabbitmq/bin/rabbitmq-server
    rabbitmq    85     1  0 10:47 ?        00:00:00 /usr/lib/erlang/erts-7.2/bin/epmd -daemon
    rabbitmq    98     1  0 10:47 ?        00:00:01 /usr/lib/erlang/erts-7.2/bin/beam -W w -A 64 -P 1048576 -K true -B i -- -root /usr/lib/erlang -progname erl -- -home /var/lib/rabbitmq -- -pa /usr/lib/rabbitm


### Network interfaces Up & Open

Taking into account the results of the ps commands in the previous
section, we take the PID in order to know the information about the
network interfaces up & open. To check the ports in use and listening,
execute the command:

    lsof -i | grep "$PID1\|$PID2"

Where $PID1 and $PID2 are the PIDs of the tox processes obtained
at the ps command described before, in the previous case 762 and 821
(redis-server) and 5604 (Python). The expected results must be something
similar to the following:

    COMMAND   PID USER    FD  TYPE DEVICE  SIZE/OFF NODE NAME
    murano-ap 762 root    4u  IPv4 791813      0t0  TCP ac7d13082086:48456->rabbit:amqp (ESTABLISHED)
    murano-ap 762 root    5u  IPv4 791816      0t0  TCP *:8082 (LISTEN)
    murano-ap 762 root    6u  IPv4 791817      0t0  TCP ac7d13082086:48457->rabbit:amqp (ESTABLISHED)
    murano-ap 762 root    9u  IPv4 791953      0t0  TCP ac7d13082086:54643->130.206.84.8:4731 (CLOSE_WAIT)
    murano-ap 762 root   11u  IPv4 791967      0t0  TCP ac7d13082086:54647->130.206.84.8:4731 (CLOSE_WAIT)
    murano-en 821 root    4u  IPv4 792083      0t0  TCP ac7d13082086:48475->rabbit:amqp (ESTABLISHED)


### Databases


The last step in the sanity check, once that we have identified the
processes and ports is to check the database that have to be up and
accept queries. For the first one, if we execute the following commands
inside the code of the rule engine server:

    $ mysql -h mysqlhost -u user -p

Where user is the administration user defined for murano database. The previous
command should ask you for the password and after that show you:

    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 155286
    Server version: 5.6.14 MySQL Community Server (GPL)

    Copyright (c) 2000, 2013, Oracle and/or its affiliates. All rights reserved.

    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    mysql>

In order to show the different tables contained in this database, we
should execute the following commands with the result that we show here:

    mysql> show tables from murano;
    +----------------------+
    | Tables_in_murano     |
    +----------------------+
    | alembic_version      |
    | apistats             |
    | category             |
    | cf_orgs              |
    | cf_serv_inst         |
    | cf_spaces            |
    | class_definition     |
    | environment          |
    | environment-template |
    | instance_stats       |
    | locks                |
    | package              |
    | package_to_category  |
    | package_to_tag       |
    | session              |
    | status               |
    | tag                  |
    | task                 |
    +----------------------+
    18 rows in set (0.00 sec)


## Diagnosis Procedures

The Diagnosis Procedures are the first steps that a System Administrator
will take to locate the source of an error in a GE. Once the nature of
the error is identified with these tests, the system admin will very
often have to resort to more concrete and specific testing to pinpoint
the exact point of error and a possible solution. Such specific testing
is out of the scope of this section.

### Resource availability

The resource availability in the node should be at least 2Gb of RAM and
8GB of Hard disk in order to prevent enabler’s bad performance in both
nodes. This means that bellow these thresholds the enabler is likely to
experience problems or bad performance.

###  Remote Service Access

We have internally two components to connect, the API and the engine (besides the database manager and the
message bus). After that two internals component, we
should connect with the the IdM GE. An administrator to verify that such
links are available will use this information.

The first step is to check that the api is up and running, for
this purpose we can execute the following curl command, which is a
simple GET operation:

    root@fiware:~# curl http://$IP:$PORT/v1.0

The variable will be the IP direction in which we have installed the murano service. This request should return the status of the server if it
is working properly.


In order to check the connectivity between the rule engine and the IdM
GE, due to it must obtain a valid token and tenant for a user and
organization with the following curl commands:

    root@fiware:~# curl
    -d '{"auth": {"tenantName": "<MY_ORG_NAME>",
    "passwordCredentials":{"username": "<MY_USERNAME>", "password": "<MY_PASS>"}}}'
    -H "Content-type: application/json" -H "Accept: application/xml"
    http://<KEYSTONE_HOST>:<KEYSTONE_PORT>/v2.0/tokens

The will be the name of my Organization/Tenant/Project predefined in the
IdM GE (aka Keystone). The and variables will be the user name and
password predefined in the IdM GE and finally the and variables will be
the IP direction and port in which we can find the IdM GE (aka
Keystone). This request should return one valid token for the user
credentials together with more information in a xml format:

    <?xml version="1.0" encoding="UTF-8"?>
    <access xmlns="http://docs.openstack.org/identity/api/v2.0">
      <token expires="2012-06-30T15:12:16Z" id="9624f3e042a64b4f980a83afbbb95cd2">
        <tenant enabled="true" id="30c60771b6d144d2861b21e442f0bef9" name="FIWARE">
          <description>FIWARE Cloud Chapter demo project</description>
        </tenant>
      </token>
      <serviceCatalog>
      …
      </serviceCatalog>
      <user username="fla" id="b988ec50efec4aa4a8ac5089adddbaf9" name="fla">
        <role id="32b6e1e715f14f1dafde24b26cfca310" name="Member"/>
      </user>
    </access>

With this information (extracting the token id), we can perform a GET
operation to Murano service to check that the database is working. For this purpose we can execute
the following curl commands:

    curl -v -H 'X-Auth-Token: a9a861db6276414094bc1567f664084d'
    -X GET "http://<I$P>:8082/v1/catalog/packages"

The variable will be the IP direction in which we have installed the
Rule engine API functionality. This request should return the packages already
uploaded. In case we have not upload anyone, it will just show the core library:

    {
        "packages":
        [
            ...
        ]
    }

### Resource consumption
No issues related to resources consumption have been detected.


### I/O flows

The rule engine application is hearing from port 8082. Please refer to
the installation process in order to know exactly which was the port
selected.



