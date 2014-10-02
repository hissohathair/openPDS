#!/bin/sh
#
# openpds_run
#
#    Runs openPDS as a server. For now, just running using
#    Python/Django standalone server. The first time this is run, it
#    will perform some initialisation steps.
#
#    The script assumes openPDS has been installed in /home/app/pdsEnv
#

# Settings
APP_DIR=/home/app/pdsEnv
LOG_DIR=/var/log/openpds
RUN_DIR=/var/www/trustframework/simplePdsEnv
ENV_DIR=$RUN_DIR/envdir
DATA_DIR=$RUN_DIR/openPDS/openpds
USER=app

export USER

if [ -d "$APP_DIR" ] ; then
    cd "$APP_DIR"
else
    echo "$0: error -- expect openPDS to be in $APP_DIR"
    exit 255
fi

# Activate Python virtual environment
if [ -f "./bin/activate" ] ; then
    . ./bin/activate
else
    echo "$0: error -- not in correct build directory"
    exit 255
fi

# Set up environent for chpst
test -d $ENV_DIR || mkdir -p $ENV_DIR
echo $USER > $ENV_DIR/USER

test -d $LOG_DIR || mkdir -p $LOG_DIR
date > $LOG_DIR/openpds.log

# Initialise on first run
if [ ! -d "$DATA_DIR" ] ; then
    echo "$0: Initialising $DATA_DIR"
    mkdir -p "$DATA_DIR"
    chown -R $USER:$USER "$DATA_DIR"
    chpst -u $USER -e $ENV_DIR python manage.py syncdb --noinput
fi

if [ ! -e $RUN_DIR/bin ] ; then
    ln -s $APP_DIR/bin $RUN_DIR/bin
fi



# Run as server
echo "$0: Logging to $LOG_DIR"
exec chpst -u $USER -e $ENV_DIR python manage.py runserver 0.0.0.0:8002 >>$LOG_DIR/openpds.log 2>&1
