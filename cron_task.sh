#!/bin/bash

source $1/.env

echo $RAILS_ENV

echo $TRANSMISSION_URL
echo $REDIS_HOST
echo $SLICE_DIR

$1/bin/rails runner $1/lib/$2.rb
