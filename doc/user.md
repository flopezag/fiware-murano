# FIWARE Murano - User & Programmer's Guide


## Introduction

Welcome the User and Programmer Guide for the Application Management Generic
Enabler (Murano). The online documents are being continuously updated and
improved, and so will be the most appropriate place to get the most up
to date information on using this interface.

### Background and Detail

This User and Programmers Guide relates to the Application Management GE which
is part of the [Cloud Hosting Chapter](https://forge.fiware.org/plugins/mediawiki/wiki/fiware/index.php/Cloud_Hosting_Architecture). Please find more information
about this Generic Enabler in the following [Open Specification](https://forge.fiware.org/plugins/mediawiki/wiki/fiware/index.php/FIWARE.OpenSpecification.Cloud.AppManagement).

## User Guide

The Murano GE is a backend component, without user interface. The Cloud Portal can
be used for Web-based interaction as well as the [murano-dashboard](https://github.com/openstack/murano-dashboard),
which is is an extension for [OpenStack Dashboard](https://github.com/openstack/horizon) that provides a UI for Murano.
Both are not part of this GE.


## Programmer Guide

The Murano service API is a programmatic interface used for interaction with Murano. You can obtain more
details about it in the following page [OpenStack Murano API](http://docs.openstack.org/developer/murano/specification/index.html).

In Murano, each application, as well as the form of application data entry, is defined by its package.
Murano allows you to import and manage packages as well as add applications from catalog to environments.
In addition, it is possible create your own packages and include them into the catalog. The next link,
[Step-by-Step Application Package Creation](https://murano.readthedocs.io/en/stable-liberty/draft/appdev-guide/step_by_step.html),
walks you through the steps that should be taken while composing an application package to get it ready for uploading to Murano.
