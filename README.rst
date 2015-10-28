# fiware-murano
FIWARE Cloud implementations of the OpenStack Murano components with docker

#Requirements

* Install compose_

#How to create murano image
 
    cd fiwaremurano
    docker build . -t fiware-murano
    
#How to create murano-dashboard image

    cd dashboard
    docker build . -t murano-dashboard
    
**Start containers using docker-compose:**
 
    export PASSWORD=<openstack admin password>
    docker-compose -f docker-compose-dashboard.yml up


       
.. REFERENCES

.. _compose: http://docs.docker.com/compose/install/