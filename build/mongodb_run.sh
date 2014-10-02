#!/bin/sh

/usr/bin/mongod --unixSocketPrefix=/var/run/mongodb --config /etc/mongodb.conf run
