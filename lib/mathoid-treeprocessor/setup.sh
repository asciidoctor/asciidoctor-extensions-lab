#!/bin/sh

npm --version > /dev/null 2>&1

if [ $? != 0 ]; then
  echo 'Please install the Node package manager (npm).'
  exit 1
fi

if [ $(npm list phantomjs | grep -c phantomjs) == 0 ]; then
  npm install phantomjs
fi

if [ ! -d mathoid ]; then
  #git clone --recursive https://github.com/gwicke/mathoid
  git clone -b integration --recursive https://github.com/mojavelinux/mathoid
fi

# Make sure you can run the following command:
#
# cd mathoid
# phantomjs main.js
#
# Press Ctrl+C if you see no errors.
