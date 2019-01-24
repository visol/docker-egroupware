# Introduction

Dockerfile to build a eGroupware container image.

## Version

Current Version: **17.1.20171115**

# Quick Start

You can launch the image using the docker command line,

```
#!/usr/bin/env bash

mkdir -p /opt/egroupware-db/data
docker run -d \
 	--name egroupware-mariadb \
	 -e MYSQL_ROOT_PASSWORD=MySuperSecretSqlPassword \
	 -e MYSQL_DATABASE=egroupware \
	 -e MYSQL_USER=egroupware \
	 -e MYSQL_PASSWORD=AnotherSecretPassword \
	 -v /opt/egroupware-db/data:/var/lib/mysql \
	 mariadb:latest

mkdir -p /opt/egroupware/data
docker run -d \
  --name egroupware \
  -e EGROUPWARE_HEADER_ADMIN_USER=admin \
  -e EGROUPWARE_HEADER_ADMIN_PASSWORD=123456 \
  -e EGROUPWARE_CONFIG_USER=admin \
  -e EGROUPWARE_CONFIG_PASSWD=123456 \
  -p 10080:80 \
  -v /opt/egroupware/data:/var/lib/egroupware \
  --link egroupware-mariadb:mysql \
  visol/egroupware:latest
```

Point your browser to `http://localhost:10080/egroupware/setup/` and login with the defined username and password:

* username: **admin**
* password: **123456**

A wizard will guide you through the installation of the database and will set up your first user.

## References
  * http://www.egroupware.org/
  * http://www.egroupware.org/fileadmin/content/Get_help/EPL_Installation_instructions/DE-Stylite-EPL-Installation.html#K11
