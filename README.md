#<a name="top"></a>FIWARE Application Manager GE: Murano

[![License badge](https://img.shields.io/badge/license-Apache_2.0-blue.svg)](LICENSE)
[![Documentation badge](https://readthedocs.org/projects/fiware-murano/badge/?version=latest)](http://fiware-murano.readthedocs.org/en/latest/?badge=latest)
[![Docker badge](https://img.shields.io/docker/pulls/fiware/murano.svg)](https://hub.docker.com/r/fiware/murano/)
[![Support badge]( https://img.shields.io/badge/support-sof-yellowgreen.svg)](http://stackoverflow.com/questions/tagged/fiware-murano)

* [Introduction](#introduction)
* [GEi overall description](#gei-overall-description)
* [Build and Install](#build-and-install)
* [API Overview](#api-overview)
* [Testing](#testing)
    * [Unit Tests](#unit-tests)
    * [End-to-end tests](#end-to-end-tests)
* [Advanced topics](#advanced-topics)
* [Support](#support)
* [License](#license)


## Introduction

This is the code repository for **FIWARE Application Manager GE - Murano**, FIWARE Cloud implementations of the OpenStack Murano components with docker. We are working directly over OpenStack Community so the information that we keep here is specific to the FIWARE implementation. The rest can be found in the OpenStack Community directly.

This project is part of [FIWARE](http://www.fiware.org). Check also the [FIWARE Catalogue entry for Murano](http://catalogue.fiware.org/enablers/application-management-murano)

Any feedback on this documentation is highly welcome, including bugs, typos
or things you think should be included but aren't. You can use [github issues](https://github.com/telefonicaid/fiware-murano/issues/new) to provide feedback.

[Top](#top)

## GEi overall description
The Murano Project introduces an application catalog to OpenStack, enabling application developers and cloud administrators to publish various cloud-ready applications in a browsable categorized catalog. Cloud users -- including inexperienced ones -- can then use the catalog to compose reliable application environments with the push of a button.

The key goal is to provide UI and API which allows to compose and deploy composite environments on the Application abstraction level and then manage their lifecycle. The Service should be able to orchestrate complex circular dependent cases in order to setup complete environments with many dependent applications and services. However, the actual deployment itself will be done by the existing software orchestration tools (such as Heat), while the Murano project will become an integration point for various applications and services.

For latest releases of Murano please refer to [OpenStack releases](http://releases.openstack.org) For release notes of Murano projects please refer to release note pages for [murano](http://docs.openstack.org/releasenotes/murano/index.html), [murano-dashboard](http://docs.openstack.org/releasenotes/murano-dashboard/index.html), [python-muranoclient](http://docs.openstack.org/releasenotes/python-muranoclient/index.html), and [murano-agent](http://docs.openstack.org/releasenotes/murano-agent/index.html). 

FIWARE Murano, keep the specific configuration of OpenStack Murano to be applied in FIWARA Lab environment besides with the docker file to use Murano with dockers.

[Top](#top)

## Build and install

### Installing OpenStack Murano

If you planned to install Murano from the OpenStack you can follow the oficial [OpenStack Murano Installation Guide](http://murano.readthedocs.io/en/stable-liberty/install/index.html)


### Installing FIWARE Murano specific requirements

In addition to the oficial Murano documentation, to be FIWARE Murano aware, we need to install some extensions to Murano core library.
It involves mainly the addition of:

-   the FiwareMuranoInstance instance: this is a Murano instance which includes the region and the GE NID (in case required) in the deployed VMs. This is
 required for FIWARE monitoring.
-   the script key: There is a support script which includes a support key to be used by region administrators to give support to users.
-   the murano agent configuration file: It includes different murano-agent configuration files for services to be included in the different
  linux distributions.

#### Installing FIWARE Murano requirements by an script
fiware-murano repository contains a script which installs all the FIWARE specific requirements. This script is in charge of:
- creating the virtualenv,
- installing the Murano CLI, required for uploading Murano specific requirements,
- generating the zip file including Murano specific requirements,
- uploading the core library, including the specifc requirements into Murano instance.

To execute it, it is required to export admin credentials to access to the Cloud, where Murano is part of.

    $ export OS_USERNAME={the admin user name}
    $ export OS_PASSWORD={the password for admin user}
    $ export OS_TENANT_NAME={the admin tenant name}
    $ export OS_REGION_NAME={the region}
    $ export OS_AUTH_URL={the auth url for keystone}

Then, just go to folder scripts and execute the script (this script should be executed inside scripts folder):
    $ cd scripts
    $ ./upload_fiware_things.sh

#### Installing FIWARE Murano requirements manually
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

Then, we execute the command package-import for the Murano client library (considering we are configuring Murano against FIWARE Lab)

    $ tox -e venv -- murano --murano-url http://localhost:8082 --os-username $OS_ADMIN_USERNAME --os-password $OS_PASSWORD \
    --os-tenant-name $OS_ADMIN_USERNAME --os-auth-url=$OS_AUTH_URL\
    package-import --exists-action u  --is-public io.murano.zip

## Configuration
### Configuring multiple regions
Murano can works on top of several Heat in different regions, allowing for deploying blueprint templates in different regions. It requires to configure some information about the regions like it is explained in the [oficial documentation](http://docs.openstack.org/developer/murano/articles/multi_region.html). Concretely, it should exist a file called io.murano.Environment.yaml in the folder specified in the class_configs property. In this file information about the rabbit should be configured. 

[Top](#top)

## API Overview

The murano service API is a programmatic interface used for interaction with murano. You can obtain more details about it in the following page [OpenStack Murano API](http://docs.openstack.org/developer/murano/specification/index.html).

[Top](#top)

## Testing

### Unit tests
Murano has a suite of tests that are run on all submitted code, and it is recommended that developers execute the tests themselves to catch regressions early. Developers are also expected to keep the test suite up-to-date with any submitted code changes. See [Murano Unit Tests](http://docs.openstack.org/developer/murano/guidelines.html#testing-guidelines) for more details.

### End-to-end tests
All Murano services have tempest-based automated tests, which allow to verify API interfaces and deployment scenarios. See [Murano automated tests tempest tests](http://murano.readthedocs.io/en/stable-liberty/articles/test_docs.html#murano-automated-tests-tempest-tests) for more details.

[Top](#top)

## Advanced topics

* [Welcome to Murano Documentation](http://murano.readthedocs.io/en/stable-liberty/)
* [Murano workflow](http://murano.readthedocs.io/en/stable-liberty/articles/workflow.html)
* Container-based deployment
  * [Docker](docker/README.md)
* [Development Guidelines](http://murano.readthedocs.io/en/stable-liberty/guidelines.html)
* [Contribution guidelines](http://murano.readthedocs.io/en/stable-liberty/contributing.html), especially important if you plan to contribute with code
  to OpenStack Murano.
* [Murano TroubleShooting and Debug Tips](http://murano.readthedocs.io/en/stable-liberty/articles/debug_tips.html)

[Top](#top)

## Support

Ask your thorough programmming questions using [stackoverflow](http://stackoverflow.com/questions/ask)
and your general questions on [FIWARE Q&A](https://ask.fiware.org). In both cases please use the tag `fiware-murano`

[Top](#top)

## License

\(c) 2015-2016 Telefónica I+D, Apache License 2.0
