===================
 FIWARE Monitoring
===================

|License Badge| |Documentation Badge| |StackOverflow| |Build Status| |Coverage Status| 

This is the code repository for FIWARE Murano, the reference implementation
of the Application Management GE.

This project is part of FIWARE_. Check also the
`FIWARE Catalogue entry for Murano`__.

__ `FIWARE Catalogue - Murano GE`_

Any feedback on this documentation is highly welcome, including bugs, typos
or things you think should be included but aren't. You can use `github issues`__
to provide feedback.

__ `FIWARE Murano - GitHub issues`_

For documentation previous to release 4.4.2 please check the manuals at Murano
public wiki:

- `FIWARE Murano - User and Programmers Guide`_
- `Murano Overview`_


GEi overall description
=======================

FIWARE Application Management GEri - Murano provides the basic support for hardware deployment
management (virtual servers, networks...) and software installation management.
This includes both the application provisioning phase for as well as the on going
life-cycle management of applications. The application management services interacts with
the Compute service, Image service, and Network service by using the Orchestrator service
in order to management the whole infrastructure. Hence, Murano introduces an application catalog
to OpenStack, enabling application developers and cloud administrators to publish various
cloud-ready applications in a browsable categorized catalog. The main capabilities provided
for a cloud hosting user are:

Application Catalogue, including all the software to be instantiated
Deploy of complex application configuration in terms of blueprint templates
Support for configuration languages (such as puppet or chef) for the installation of the software
Manage life cycle of the application


Build and Install
=================




Requirements
------------




Installation
------------



Upgrading from a previous version
---------------------------------




Running
=======



Configuration file
------------------


Checking status
---------------


API Overview
============


API Reference Documentation
---------------------------

- `_ Murano - Api`__

__ `_ Murano - Api`_


Testing
=======

End-to-end tests
----------------




Unit tests
----------



Acceptance tests
----------------



Advanced topics
===============




License
=======

\(c)  Apache License 2.0


.. IMAGES

.. |Build Status| image:: https://travis-ci.org/telefonicaid/fiware-monitoring.svg?branch=develop
   :target: https://travis-ci.org/telefonicaid/fiware-monitoring
   :alt: Build Status
.. |Coverage Status| image:: https://img.shields.io/coveralls/telefonicaid/fiware-monitoring/develop.svg
   :target: https://coveralls.io/r/telefonicaid/fiware-monitoring
   :alt: Coverage Status
.. |StackOverflow| image:: https://img.shields.io/badge/support-sof-yellowgreen.svg
   :target: https://stackoverflow.com/questions/tagged/fiware-monitoring
   :alt: Help, ask questions
.. |License Badge| image:: https://img.shields.io/badge/license-Apache_2.0-blue.svg
   :target: ngsi_adapter/LICENSE
.. |Documentation Badge| image:: https://readthedocs.org/projects/fiware-monitoring/badge/?version=latest
   :target: http://fiware-monitoring.readthedocs.org/en/latest/?badge=latest
   :alt: License


.. REFERENCES

.. _FIWARE: http://www.fiware.org
.. _FIWARE Catalogue - Murano GE: http://catalogue.fiware.org/enablers/application-management-murano
.. _FIWARE Murano - GitHub issues: https://github.com/telefonicaid/fiware-murano/issues/new
.. _Murano - User and Programmers Guide: http://murano.readthedocs.io/en/stable-kilo/
.. _FIWARE Murano - Forge files area: https://forge.fiware.org/plugins/mediawiki/wiki/fiware/index.php/OpenStack_Murano
.. _Murano Overview: https://wiki.openstack.org/wiki/Murano/ApplicationCatalog
.. _Murano - Api: http://murano.readthedocs.io/en/stable-kilo/specification/index.html

