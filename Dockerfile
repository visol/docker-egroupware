FROM php:5.5-apache

RUN apt-get update && apt-get -y install wget bzip2 && rm -r /var/lib/apt/lists/*

RUN a2enmod rewrite

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-jpeg-dir=/usr/lib \
	&& docker-php-ext-install gd
RUN docker-php-ext-install mysqli
#RUN docker-php-ext-install mysql
RUN docker-php-ext-install pdo_mysql
RUN apt-get update && apt-get -y install re2c libmcrypt-dev && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-install mcrypt
RUN apt-get update && apt-get -y install zlib1g-dev && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-install zip \
	&& apt-get purge --auto-remove -y zlib1g-dev
RUN apt-get update && apt-get -y install libssl-dev libc-client2007e-dev libkrb5-dev && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
	&& docker-php-ext-install imap
RUN docker-php-ext-install mbstring


RUN pear install channel://pear.php.net/HTTP_WebDAV_Server-1.0.0RC8
RUN pear install Auth_SASL
RUN pear install Net_IMAP
RUN pear install XML_Feed_Parser
RUN pear install pear install Net_Sieve

RUN apt-get update && apt-get -y install tnef && rm -rf /var/lib/apt/lists/*

#VOLUME /var/www/html


RUN curl -o jpgraph.tar.gz -SL "http://jpgraph.net/download/download.php?p=5" \
	&& mkdir -p /var/www/html/jpgraph \
	&& tar -xzf jpgraph.tar.gz --strip-components=1 -C /var/www/html/jpgraph \
	&& rm jpgraph.tar.gz

#ENV EGROUPWARE_VERSION 14.1.20141219
ENV EGROUPWARE_VERSION 1.8.007.20140512
ENV EGROUPWARE_UPSTREAM_VERSION 1.8

RUN curl -o egroupware.tar.bz2 -SL http://sourceforge.net/projects/egroupware/files/eGroupware-${EGROUPWARE_UPSTREAM_VERSION}/eGroupware-${EGROUPWARE_VERSION}/eGroupware-${EGROUPWARE_VERSION}.tar.bz2/download \
	&& tar -xjf egroupware.tar.bz2 -C /var/www/html \
	&& rm egroupware.tar.bz2
RUN curl -o egroupware-egw-pear.tar.bz2 -SL http://sourceforge.net/projects/egroupware/files/eGroupware-${EGROUPWARE_UPSTREAM_VERSION}/eGroupware-${EGROUPWARE_VERSION}/eGroupware-egw-pear-${EGROUPWARE_VERSION}.tar.bz2/download \
	&& tar -xjf egroupware-egw-pear.tar.bz2 -C /var/www/html \
	&& rm egroupware-egw-pear.tar.bz2


COPY assets/egroupware.php.ini /usr/local/etc/php/conf.d/egroupware.ini
COPY assets/header.inc.php /var/www/html/egroupware/

EXPOSE 80
