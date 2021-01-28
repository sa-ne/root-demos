#!/bin/bash

# Constants
. ./env.sh


# set Twistlock console user/pass
if ! curl -v -k -H 'Content-Type: application/json' -X POST \
     -d "{\"username\": \"$TWISTLOCK_CONSOLE_USER\", \"password\": \"$TWISTLOCK_CONSOLE_PASSWORD\"}" \
     https://$TWISTLOCK_EXTERNAL_ROUTE/api/v1/signup; then

    echo "Error creating Twistlock Console user $TWISTLOCK_CONSOLE_USER"
    exit 1
fi

# Set Twistlock license. Using default user/pass
if ! curl -v -k \
  -u $TWISTLOCK_CONSOLE_USER:$TWISTLOCK_CONSOLE_PASSWORD \
  -H 'Content-Type: application/json' \
  -X POST \
  -d "{\"key\": \"$TWISTLOCK_LICENSE\"}" \
  https://$TWISTLOCK_EXTERNAL_ROUTE/api/v1/settings/license; then

    echo "Error uploading Twistlock license to console"
    exit 1
fi
