#!/bin/bash

source .env

echo $RAILS_ENV

echo $TRANSMISSION_URL
echo $REDIS_HOST
echo $SLICE_DIR

$1/bin/rails runner $2
