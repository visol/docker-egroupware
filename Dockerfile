FROM php:5.5-apache
MAINTAINER Jonas Renggli <jonas.renggli@visol.ch>

RUN apt-get update \
	&& apt-get -y install wget bzip2 pwgen \
	&& rm -r /var/lib/apt/lists/*

RUN a2enmod rewrite

# install the PHP extensions we need
RUN apt-get update \
	&& apt-get install -y libpng12-dev libjpeg-dev \
	&& docker-php-ext-configure gd --with-jpeg-dir=/usr/lib \
	&& docker-php-ext-install gd \
	&& docker-php-ext-install mysqli \
	&& docker-php-ext-install pdo_mysql \
	&& apt-get -y install re2c libmcrypt-dev \
	&& docker-php-ext-install mcrypt \
	&& apt-get -y install zlib1g-dev \
	&& docker-php-ext-install zip \
	&& apt-get purge --auto-remove -y zlib1g-dev \
	&& apt-get -y install libssl-dev libc-client2007e-dev libkrb5-dev \
	&& docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
	&& docker-php-ext-install imap \
	&& docker-php-ext-install mbstring \
	&& rm -rf /var/lib/apt/lists/*

# install PHP PEAR extensions
RUN pear install channel://pear.php.net/HTTP_WebDAV_Server-1.0.0RC8 \
	&& pear install Auth_SASL \
	&& pear install Net_IMAP \
	&& pear install XML_Feed_Parser \
	&& pear install pear install Net_Sieve

# PHP extensions for 14.1
RUN apt-get update \
	&& apt-get -y install libtidy-dev \
	&& docker-php-ext-install tidy \
	&& docker-php-ext-install bcmath \
	&& rm -rf /var/lib/apt/lists/*

# PHP PEAR extensions for 14.1
RUN pear channel-discover pear.horde.org \
	&& pear install pear.horde.org/Horde_Mail \
	&& pear install pear.horde.org/Horde_Imap_Client \
	&& pear install pear.horde.org/Horde_Nls \
	&& pear install pear.horde.org/Horde_Smtp \
	&& pear install pear.horde.org/Horde_Compress \
	&& pear install pear.horde.org/Horde_Icalendar \
	&& pear install pear.horde.org/Horde_Mapi

RUN apt-get update \
	&& apt-get -y install tnef \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -o jpgraph.tar.gz -SL "http://jpgraph.net/download/download.php?p=5" \
	&& mkdir -p /var/www/html/jpgraph \
	&& tar -xzf jpgraph.tar.gz --strip-components=1 -C /var/www/html/jpgraph \
	&& rm jpgraph.tar.gz

ENV EGROUPWARE_VERSION 14.3.20160428
ENV EGROUPWARE_UPSTREAM_VERSION 14.3

RUN curl -o egroupware-epl.tar.bz2 -SL http://sourceforge.net/projects/egroupware/files/eGroupware-${EGROUPWARE_UPSTREAM_VERSION}/eGroupware-${EGROUPWARE_VERSION}/egroupware-epl-${EGROUPWARE_VERSION}.tar.bz2/download \
	&& tar -xjf egroupware-epl.tar.bz2 -C /var/www/html \
	&& rm egroupware-epl.tar.bz2

COPY docker-entrypoint.sh /entrypoint.sh
COPY assets/header.inc.php /var/www/html/egroupware/header.inc.php
COPY assets/egroupware.php.ini /usr/local/etc/php/conf.d/egroupware.ini
COPY assets/apache.conf /etc/apache2/apache2.conf

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
CMD ["app:start"]
