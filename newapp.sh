#!/bin/bash
#
# Grab the Vitals
# ---------------
#
# You will need installed:
#
#  * git
#  * apache
#  * php 5.2+
#

# Default
DEFAULT_APP_PATH="$HOME/koapp"

if [ -n  "$1" ];
then
	# Use first arg as application path
	APP_NAME="$1"
else
	# Request application name
	echo "Please provide a path in which to install your new Kohana application: "
	read CUSTOM_APP_PATH

	# Set app path
	if [ -n "$CUSTOM_APP_PATH" ];
	then
		APP_NAME="$CUSTOM_APP_PATH"
	else
		APP_NAME="$DEFAULT_APP_PATH"
	fi
fi

# Use app name
echo "Using $APP_NAME as application path..."

if [ ! -d "$APP_NAME" ];
then
	# Create folder in application path
	echo "Creating application path..."
	mkdir -p $APP_NAME
fi

# Go go go...
cd $APP_NAME

# Create application folders with correct perms
echo "Creating application folders..."
mkdir {application,modules}
mkdir application/{classes,public,cache,logs}
chmod 0777 application/cache application/logs

# Init repo
echo "Initialising application folder as git repo..."
git init > /dev/null

# Grab bootstrap and index
echo "Getting bootstrap.php and index.php..."
wget https://github.com/kohana/kohana/raw/3.1/master/application/bootstrap.php --output-file=application/bootstrap.php
wget https://github.com/kohana/kohana/raw/3.1/master/index.php --output-file=application/public/index.php

# Get system files
echo "Cloning Kohana Core into system..."
git submodule add https://github.com/kohana/core.git system > /dev/null 2>&1

# Install Kostache?
echo "Would you like to install Kostache (y/n)?"
read KOSTACHE

if [ "$KOSTACHE" == "y" ];
then
	# Install Kostache
	echo "Cloning zombor's Kostache into system..."
	git submodule add https://github.com/zombor/KOstache.git modules/kostache > /dev/null 2>&1
	mkdir application/templates
fi

# Ensure submodules initialised
echo "Initialising submodules..."
git submodule update --init  > /dev/null

# Commit changes
echo "Commiting original sin...." 
git add . > /dev/null
git commit -m "My base Kohana setup for $APP_NAME" > /dev/null

echo "Done."