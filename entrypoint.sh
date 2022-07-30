#!/bin/sh

/bin/sh -c crond &

/work/start.sh &

nginx -g "daemon off;"