#!/bin/bash

source .env

echo $RAILS_ENV

echo $TRANSMISSION_URL
echo $REDIS_HOST
echo $SLICE_DIR

bin/rails s -d
