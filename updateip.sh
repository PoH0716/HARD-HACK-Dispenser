#!/bin/bash

IPADDR="$(ip addr show wlan0 | grep -Po 'inet \K[\d.]+')"
curl -G http://curtisrlee.com/iot/data/test/update.php?ip=$IPADDR
