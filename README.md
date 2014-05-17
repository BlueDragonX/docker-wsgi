Docker WSGI Image
=================
A Docker image for hosting WSGI apps.

What's In It
------------
The image uses Nginx and uWSGI to host WSGI apps. Both run under the app user.
All logs are piped through syslog-ng so there's nothing to collect. And it
exposes ports 80 and 443. The app should be a volume mounted at /app and
contain a uwsgi.yaml and nginx.conf file to configure uWSGI and the nginx
server section(s) for the app. There may be multiple nginx config files loaded
as long as they each match the pattern nginx*.conf.

Building
--------
We build it this way:

    git clone https://github.com/BlueDragonX/docker-wsgi.git
    docker build --rm -t bluedragonx/wsgi docker-wsgi

Running
-------
The /app directory contains an nginx.conf to listen on port 80 and a uwsgi.yml
file to host the Python demo WSGI app. So to run the sampe app you could:

    docker run -P bluedragonx/wsgi

And to run your own app you might:

    docker run -P -v /path/to/my/app:/app bluedragonx/wsgi

By default Nginx starts with 2 workers and so does uWSGI. You can change that
with environment variables as well:

    docker run -P -e NGINX_WORKERS=4 -e UWSGI_WORKERS=16 bluedragonx/wsgi

Inheriting
----------
The image supports backing in the app by an inheriting container. This is as
easy as loading your own app contents with an ADD. However, you may want to
load your own system-wide Nginx or uWSGI configs. To do this you should set the
DISABLE_APP_CONFIG to a non-empty value in your Dockerfile. This will prevent
the image from loading configuration from the /app directory.

License
-------
Copyright (c) 2014 Ryan Bourgeois. Licensed under BSD-Modified. See the LICENSE
file for a copy of the license.
