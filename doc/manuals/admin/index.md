=======================================
 Installation and Administration Guide
=======================================

## Introduction

This guide defines the procedure to install the different components that build
up the FIWARE Murano GE,

For general information, please refer to GitHub's README_.

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

Then, we need to include this instance in the Murano library manifest.yaml. Go to murano folder and execute:

    $  echo "  io.murano.resources.FiwareMuranoInstance: resources/FiwareMuranoInstance.yaml" >> meta/io.murano/manifest.yaml

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

Finally, we execute the commando package-import for the murano client library (cosidering we are configuring murano agains FIWARE Lab)

    $ tox -e venv -- murano --murano-url http://localhost:8082 --os-username admin --os-password $PASSWORD \
    --os-tenant-name admin --os-auth-url=http://cloud.lab.fi-ware.org:4730/v2.0 \
    package-import --exists-action u  --is-public io.murano.zip


.. REFERENCES

.. _README: https://github.com/telefonicaid/fiware-murano/blob/master/README.rst

