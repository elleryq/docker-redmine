#!/bin/bash

# ignore ruby/nginx/postgresql, because they are installed in gitlab installation.
apt-get update \
 && apt-get install -y supervisor logrotate nginx mysql-client postgresql-client \
      imagemagick subversion git cvs bzr mercurial rsync ruby2.1 locales openssh-client \
      gcc g++ make patch pkg-config ruby2.1-dev libc6-dev zlib1g-dev libxml2-dev \
      libmysqlclient18 libpq5 libyaml-0-2 libcurl3 libssl1.0.0 \
      libxslt1.1 libffi6 zlib1g gsfonts zlib1g-dev libxapian-dev uuid-dev \
 && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX \
 && gem install --no-document bundler

mkdir -p /app1
cp -r assets/setup/ /app1/setup/
chmod 755 /app1/setup/install
/app1/setup/install

cp -r assets/config/ /app1/setup/config/
cp assets/init /app1/init
chmod 755 /app1/init

mkdir -p /home/redmine/data
mkdir -p /var/log/redmine

# Initialize database
mysql < redmine.sql

cat > /app1/env << END
DB_USER=redmine
DB_PASS=redmine
DB_NAME=redmine_production
DB_HOST=localhost
DB_PORT=3306
DB_TYPE=mysql
REDMINE_RELATIVE_URL_ROOT=/redmine
SMTP_USER=
SMTP_PASS=
END

rm -f /etc/nginx/site-enabled/redmine
mv /etc/nginx/site-enabled/gitlab old_nginx_gitlab
cp new_nginx_gitlab /etc/nginx/sites-enabled/gitlab

