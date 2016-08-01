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
    * [Ent-to-end tests](#ent-to-end-tests)
    * [Unit Tests](#unit-tests)
* [Advanced topics](#advanced-topics)
* [License](#license)
* [Support](#support)

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

If you planned to install Murano from the OpenStack you can follow the oficial [OpenStack Murano Installation Guide](http://docs.openstack.org/developer/murano/install/index.html)

### Installing using dockers

It is possible deploy all Murano components following the indications of this repository. Please take a look into * [Docker management with Murano](docker/Readme.md) for more details.

#### Requirements

- Install [compose](http://docs.docker.com/compose/install/)

#### How to create murano image

    $ cd fiwaremurano
    $ docker build -t fiware-murano .
    
#### How to create murano-dashboard image

    $ cd dashboard
    $ docker build -t murano-dashboard .
    
#### Start containers using docker-compose:

    $ export PASSWORD=<openstack admin password>
    $ docker-compose -f docker-compose-dashboard.yml up

[Top](#top)

## API Overview

The murano service API is a programmatic interface used for interaction with murano. You can obtain more details about it in the following page [OpenStack Murano API](http://docs.openstack.org/developer/murano/specification/index.html).

[Top](#top)

## Testing

### Unit tests
Murano has a suite of tests that are run on all submitted code, and it is recommended that developers execute the tests themselves to catch regressions early. Developers are also expected to keep the test suite up-to-date with any submitted code changes. See [Murano Unit Tests](http://docs.openstack.org/developer/murano/guidelines.html#testing-guidelines) for more details.

### End-to-end tests
All Murano services have tempest-based automated tests, which allow to verify API interfaces and deployment scenarios. See [Murano automated tests tempest tests](http://docs.openstack.org/developer/murano/articles/test_docs.html#murano-automated-tests-tempest-tests) for more details.

[Top](#top)

## Advanced topics

* [Murano workflow](http://docs.openstack.org/developer/murano/articles/workflow.html)
* Container-based deployment
  * [Docker](docker/README.md)
* [Development Guidelines](http://docs.openstack.org/developer/murano/guidelines.html)
* [Contribution guidelines](http://docs.openstack.org/developer/murano/contributing.html), especially important if you plan to contribute with code
  to OpenStack Murano.
* [Murano TroubleShooting and Debug Tips](http://docs.openstack.org/developer/murano/articles/debug_tips.html)

[Top](#top)

## Support

Ask your thorough programmming questions using [stackoverflow](http://stackoverflow.com/questions/ask)
and your general questions on [FIWARE Q&A](https://ask.fiware.org). In both cases please use the tag `fiware-murano`

[Top](#top)

## License

\(c) 2015-2016 Telefónica I+D, Apache License 2.0
