#
# Dockerfile for openPDS
#

# Builds on openpds/common, which contains Python, pip & virtualenv
#
FROM hissohathair/openpds-common


# Set correct environment variables, etc
#
MAINTAINER Daniel Austin <daniel.austin@smartservicescrc.com.au>
ENV HOME /root


# openPDS dependencies
#
RUN apt-get -y --no-install-recommends install mongodb mongodb-server \
					       postgresql-9.3 postgresql-server-dev-9.3 postgresql-contrib-9.3 \
					       sqlite3


# Set up Python and install app dependencies using pip (virtualenv already set up)
#
ADD ./conf /home/app/pdsEnv/conf
WORKDIR /home/app/pdsEnv
RUN BASH_ENV=/home/app/pdsEnv/bin/activate bash -c "pip install -r conf/requirements.txt"

# Install the openPDS app files
# TODO: This might be better mounted as a VOLUME?

ADD ./openpds /home/app/pdsEnv/openpds
ADD ./manage.py /home/app/pdsEnv/manage.py

# Initialise runtime environment

RUN mkdir /etc/service/openpds
ADD ./build/openpds_run.sh /etc/service/openpds/run
RUN chmod 755 /etc/service/openpds/run

ADD ./build/mongodb_run.sh /etc/service/mongodb/run
RUN chmod 755 /etc/service/mongodb/run

# App runs on 8002 by default
EXPOSE 8002


# Clean up APT when done.
#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

