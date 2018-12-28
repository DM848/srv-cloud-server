#!/bin/sh
set -e

perl -pi -e "s/appname/deployment$TOKEN/g" "$CONTAINERPILOT"

/bin/containerpilot