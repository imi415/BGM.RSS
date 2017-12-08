#!/bin/bash

source .env

echo $RAILS_ENV

if [ $RAILS_ENV -eq "production" ]; then
	export SECRET_KEY_BASE=`bin/rake secret`
fi

echo $TRANSMISSION_URL
echo $REDIS_HOST
echo $SLICE_DIR

bin/rails s -d -b $LISTEN_HOST -p $LISTEN_PORT
