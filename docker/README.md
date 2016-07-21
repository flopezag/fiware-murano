
# How to use fiware-murano with Docker

There are several options to use FIWARE_MURANO very easily using docker. These are (in order of complexity):

- _"Have everything automatically done for me"_. See Section **1. The Fastest Way** (recommended).
- _"Check the acceptance tests are running properly"_ or _"I want to check that my fiware-murano instance run properly"_ . See Section **3. Run Acceptance tests**.

You do not need to do all of them, just use the first one if you want to have a fully operational Aiakos instance and maybe third one to check if your Aiakos instance run properly.

You do need to have docker in your machine. See the [documentation](https://docs.docker.com/installation/) on how to do this. Additionally, you can use the proper FIWARE Lab docker functionality to deploy dockers image there. See the [documentation](https://docs.docker.com/installation/)

----
## 1. The Fastest Way

Docker allows you to deploy an fiware-murano container in a few minutes. This method requires that you have installed docker or can deploy container into the FIWARE Lab (see previous details about it).

Consider this method if you want to try fiware-murano and do not want to bother about losing data.

Follow these steps:

1. Download [fiware-murano' source code](https://github.com/telefonicaid/fiware-murano) from GitHub (`git clone https://github.com/telefonicaid/fiware-murano.git`)
2. `cd fiware-murano/docker`
3. Using the command-line and within the directory you created type: `docker build -t fiware-murano -f Dockerfile .`.

After a few seconds you should have your fiware-murano image created. Just run the command `docker images` and you see the following response:

    REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
    fiware-murano      latest              bd78d006c2ea        About a minute ago   480.8 MB
    ...

To execute the fiware-murano image, execute the command `docker run -p 8082:8082 -d fiware-murano`. It will launch the fiware-murano service listening on port `8082`.

Check that everything works with

	curl <IP address of a machine>:8082

You can obtain the IP address of the machine just executing `docker-machine ip`. What you have done with this method is the creation of the [fiware-murano](https://hub.docker.com/r/fiware/fiware-murano/) image from the public repository of images called [Docker Hub](https://hub.docker.com/).

If you want to stop the scenario you have to execute `docker ps` and you see something like this:

    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
    b8e1de41deb5        fiware-murano      "/bin/sh -c ./start.s"   6 minutes ago       Up 6 minutes        0.0.0.0:8082->8082/tcp   fervent_davinci


Take the Container ID and execute `docker stop b8e1de41deb5` or `docker kill b8e1de41deb5`. Note that you will lose any data that was being used in Aiakos using this method.

Now is time to execute the container. This time, we take advantage of the docker compose. Just execute `docker-compose up` to launch the architecture. You can take a look to the log generated executing `docker-compose logs`. If you want to get the result of the acceptance tests, just execute `docker cp docker_fiware-murano-acceptance_1:/opt/fiware-murano/test/acceptance/testreport .`

----
## 3. Run Acceptance tests

Taking into account that you download the repository from GitHub (See Section **1. The Fastest Way**). This method will launch a container to run the E2E tests of the fiware-murano component, previously you should launch or configure a FIWARE Lab access. You have to define the following environment variables:

    export PASSWORD=<OpenStack admin user password>

Take it, You should move to the Acceptance folder `./AcceptanceTests`. Just create a new docker image executing `docker build -t fiware-murano-acceptance.`. To see that the image is created run `docker images` and you see something like this:

    REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
    fiware-murano-acceptance   latest              eadbe0b2e186        About an hour ago   579.3 MB
    fiware-murano              latest              a46ffad45e60        4 hours ago         480.8 MB
    centos                     latest              904d6c400333        2 weeks ago         196.8 MB
    ...

Now is time to execute the container. This time, we take advantage of the docker compose. Just execute `docker-compose up` to launch the architecture. You can take a look to the log generated executing `docker-compose logs`. If you want to get the result of the acceptance tests, just execute `docker cp docker_fiware-murano-acceptance_1:/opt/fiware-murano/test/acceptance/testreport .`

Please keep in mind that if you do not change the name of the image it will automatically create a new one for acceptance tests and change the previous one to tag none.

----
## 4. Other info

Things to keep in mind while working with docker containers and fiware-murano.

### 4.1 Data persistence
Everything you do with fiware-murano when dockerized is non-persistent. *You will lose all your data* if you turn off the fiware-murano container. This will happen with either method presented in this README.

### 4.2 Using `sudo`

If you do not want to have to use `sudo` follow [these instructions](http://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo).
   
