FROM php:5.5.18-apache

RUN apt-get update && apt-get -y install wget

RUN echo 'deb http://download.opensuse.org/repositories/server:/eGroupWare/Debian_7.0/ /' >> /etc/apt/sources.list.d/egroupware-epl.list \
	&& wget http://download.opensuse.org/repositories/server:eGroupWare/Debian_7.0/Release.key \
	&& apt-key add - < Release.key \
	&& rm Release.key

RUN apt-get update && apt-get -y install egroupware-epl


EXPOSE 80