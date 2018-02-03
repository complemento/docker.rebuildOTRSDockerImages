#!/bin/bash
BASE_DIRECTORY=/opt/dockerImages/
LAST_OTRS_VERSION=`/opt/src/zabbix.checkOtrsLastVersionAvailable/checkOTRSLastVersionAvailable.sh`
# LAST_OTRS_VERSION='6.0.5'

GIT_BASE=git@github.com:complemento/

REPS="docker.otrs
      docker.otrs_easy
      "
for r in $REPS
do
 cd $BASE_DIRECTORY
 rm -rf $r
 git clone ${GIT_BASE}$r
 cd $r
 # get current version from Dockerfile
 OLD_VERSION=`more Dockerfile | grep "ENV OTRS_VERSION" | awk -F "=" '{print $2}'`

 perl -pi -e "s/$OLD_VERSION/$LAST_OTRS_VERSION/g" *
 sed -i "/Older not maintained versions:/a \ - ${OLD_VERSION}" *

 git commit -a -m "Version $LAST_OTRS_VERSION"
 git push origin master
 git checkout -b $LAST_OTRS_VERSION
 git push origin $LAST_OTRS_VERSION
 git checkout master

done
