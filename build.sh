#!/bin/bash

sed "s/{{WIFI_SSID}}/$WIFI_SSID/g;s/{{WIFI_PASS}}/$WIFI_PASS/g;s/{{USER_NAME}}/$USER_NAME/g;s/{{USER_PASS}}/$USER_PASS/g" ./boards/custom/pi-baseimage.pkr.hcl > ./boards/custom/pi-baseimage.generated.pkr.hcl
packer build ./boards/custom/pi-baseimage.generated.pkr.hcl 
rm ./boards/custom/pi-baseimage.generated.pkr.hcl 
md5sum pi-baseimage.img
