FROM bluedragonx/baseimage:0.2
MAINTAINER Ryan Bourgeois <bluedragonx@gmail.com>

# set up the container environment
EXPOSE 80 443
ENTRYPOINT ["/sbin/my_init"]

# install packages
RUN echo 'deb http://ppa.launchpad.net/nginx/stable/ubuntu precise main' > /etc/apt/sources.list.d/nginx.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C && \
    apt-get update -qy && \
    apt-get install -y build-essential python-dev python-pip nginx=1.6.0-1+precise0 && \
    pip install uwsgi==2.0.4 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# create directories and special files
RUN mkdir -p /var/cache/nginx /var/lib/nginx /var/run/nginx /etc/uwsgi /etc/service/uwsgi /var/run/uwsgi && \
    mkfifo -m 0600 /var/lib/nginx/access /var/lib/nginx/errors && \
    chown app:app /var/lib/nginx/access /var/lib/nginx/errors /var/run/uwsgi

# add nginx configuration
ADD files/nginx/run /etc/service/nginx/run
ADD files/nginx/nginx.conf /etc/nginx/nginx.conf
ADD files/nginx/syslog.conf /etc/syslog-ng/conf.d/nginx.conf

# add uwsgi configuration
ADD files/uwsgi/run /etc/service/uwsgi/run

# add sample app
ADD files/app /app
