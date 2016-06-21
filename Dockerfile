FROM php:5-apache

RUN \
  echo "Acquire::http::Proxy \"http://172.16.94.245:3129\";" | tee -a /etc/apt/apt.conf.d/75proxconf && \
  echo "Acquire::https::Proxy \"http://172.16.94.245:3129\";" | tee -a /etc/apt/apt.conf.d/75proxconf && \
  cat /etc/apt/apt.conf.d/75proxconf

RUN apt-get update && apt-get install -y unzip wget php5-pgsql php5-mysql php5-dev php5-curl php5-ldap php5-sqlite sqlite3

ENV http_proxy="http://proxy.a-sis.division-savoye.ad:3129"
ENV https_proxy="http://proxy.a-sis.division-savoye.ad:3129"

RUN cd /var/www/ && wget -O kloudspeaker.zip http://www.kloudspeaker.com/download/latest.php && unzip kloudspeaker.zip -d /var/www/
RUN rm -rf /var/www/html && mv /var/www/kloudspeaker/ /var/www/html

RUN wget -O TextFile.zip http://dl.bintray.com/kloudspeaker/Kloudspeaker/viewer_TextFile_1.1.zip && unzip TextFile.zip -d /var/www/html/backend/plugin/FileViewerEditor/viewers
RUN wget -O CKEditor.zip https://github.com/sjarvela/kloudspeaker/releases/download/v2.7.8/editor_CKEditor_1.1.zip && unzip CKEditor.zip -d /var/www/html/backend/plugin

ADD configuration.php /var/www/html/backend/configuration.php
ADD sqlite.db /data/sqlite.db
RUN chmod -R 777 /data

RUN a2enmod rewrite 

VOLUME /data

EXPOSE 80

