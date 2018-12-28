#!/bin/sh

RESPONSE=$(curl -m 3 -s http://localhost:4001/health)
#echo $RESPONSE

if ("$RESPONSE" == "true")
then
    exit 0;
else
    exit 1;
fi