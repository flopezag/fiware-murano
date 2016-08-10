==============================
 Welcome to FIWARE Murano
==============================

Introduction
============

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

FIWARE Murano source code can be found here__.

__ `FIWARE Murano GitHub Repository`_


Documentation
=============

GitHub's README__ provides a good documentation summary, and the following
cover more advanced topics:

__ `FIWARE Murano GitHub README`_

.. toctree::
   :maxdepth: 1

   manuals/user/index
   manuals/admin/index


.. REFERENCES

.. _FIWARE Murano GitHub Repository: https://github.com/telefonicaid/fiware-murano.git
.. _FIWARE Murano GitHub README: https://github.com/telefonicaid/fiware-murano/blob/master/README.rst

