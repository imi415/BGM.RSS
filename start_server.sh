#!/bin/bash

source .env

echo $RAILS_ENV

export SECRET_KEY_BASE=`bin/rake secret`


echo $TRANSMISSION_URL
echo $REDIS_HOST
echo $SLICE_DIR

bin/rails s -d -b $LISTEN_HOST -p $LISTEN_PORT
