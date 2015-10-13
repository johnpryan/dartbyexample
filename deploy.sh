#!/usr/bin/env bash
CWD=`pwd`
DATE=`date +'%m/%d/%Y'`
TIME=`date +'%r'`
SOURCE_PATH=$CWD/build/web/
DESTINATION_PATH=$CWD/../blog-src/web/dartbyexample


pub build
rm -rf $DESTINATION_PATH/*
cp -r $SOURCE_PATH/* $DESTINATION_PATH
echo files copied from $SOURCE_PATH to $DESTINATION_PATH

cd $DESTINATION_PATH
git add -A
git commit -a -m "dartbyexample $DATE $TIME"
git push origin master
cd $CWD
