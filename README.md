# Introduction

Dockerfile to build a eGroupware container image.

## Version

Current Version: **1.8.007.20140512**

# Quick Start

You can launch the image using the docker command line,

```bash
mkdir -p /opt/mysql-egroupware/data
docker run -d \
--name mysql-egroupware \
-e MYSQL_ROOT_PASSWORD=MySuperSecretSqlPassword \
-e MYSQL_DATABASE=egroupware \
-e MYSQL_USER=egroupware \
-e MYSQL_PASSWORD=AnotherSecretPassword \
-v /opt/mysql-egroupware/data:/var/lib/mysql \
mysql


mkdir -p /opt/egroupware/data
docker run -d \
--name egroupware \
-e EGROUPWARE_HEADER_ADMIN_USER=admin \
-e EGROUPWARE_HEADER_ADMIN_PASSWORD=123456 \
-e EGROUPWARE_CONFIG_USER=admin \
-e EGROUPWARE_CONFIG_PASSWD=123456 \
-p 10080:80 \
-v /opt/egroupware/data:/var/lib/egroupware \
--link mysql-egroupware:mysql \
visol/egroupware:1.8.007.20140512
```

Point your browser to `http://localhost:10080/setup/` and login with the defined username and password:

* username: **admin**
* password: **123456**

A wizard will guide you through the installation of the database and will set up your first user.

## References
  * http://www.egroupware.org/
  * http://www.egroupware.org/fileadmin/content/Get_help/EPL_Installation_instructions/DE-Stylite-EPL-Installation.html#K11