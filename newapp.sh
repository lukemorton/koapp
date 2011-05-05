#!/bin/bash
#
# Kohana Application Installer
# ----------------------------
# 
# This is a small bash script for installing the core files for
# a Kohana application. Will install at the path specified a
# basic application structure, then initialises a git repository
# for your convenience. The core Kohana system files are added
# as a submodule and you are given the option to install
# Kostache because you just should!
#
# Requirements:
# 
#    * git
#
# Usage:
#   	
#     sh koapp.sh /var/www/my-new-app
#     git submodule add https://github.com/kohana/database.git modules/database
#     git submodule add https://github.com/kohana/orm.git modules/orm
#     git submodule add https://github.com/kohana/userguide.git modules/userguide
#     git add .
#     git commit -m "Added database, orm and userguide modules"
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
mkdir -p {application,modules,public}
mkdir -p application/{config,classes,cache,logs}

echo "Ensuring 777 permissions on application/log and application/cache..."
chmod 0777 application/{cache,logs}

if [ -d ".git" ];
then
	# Already a git repo
	echo "Application path is already a git repo..."
else
	# Init repo
	echo "Initialising application folder as git repo..."
	git init > /dev/null
fi

if [ ! -f "application/bootstrap.php" ];
then
	# Grab bootstrap and index
	echo "Getting bootstrap.php..."
	wget https://github.com/kohana/kohana/raw/3.1/master/application/bootstrap.php --output-document=application/bootstrap.php --no-check-certificate > /dev/null 2>&1
fi

if [ ! -f "public/index.php" ];
then
	echo "Getting index.php..."
	wget https://github.com/kohana/kohana/raw/3.1/master/index.php --output-document=public/index.php --no-check-certificate > /dev/null 2>&1
fi

if [ ! -d "system" ];
then
	# Get system files
	echo "Cloning Kohana Core into system..."
	git submodule add https://github.com/kohana/core.git system > /dev/null 2>&1
fi

install_module()
{
	MODULE_NAME=$1
	MODULE_LOCATION=$2
	
	if [ ! -d "modules/$MODULE_NAME" ];
	then
		echo "Would you like to install $MODULE_NAME (y/n)?"
		read INSTALL

		if [ "$INSTALL" == "y" ];
		then
			echo "Installing $MODULE_NAME..."
			echo "Cloning $MODULE_NAME from $MODULE_LOCATION into modules/$MODULE_NAME..."
			git submodule add "$MODULE_LOCATION" "modules/$MODULE_NAME" > /dev/null 2>&1
		fi
	fi
}

install_kostache()
{
	install_module "kostache" "https://github.com/zombor/KOstache.git"

	if [ "$INSTALL" == "y" ];
	then
		mkdir application/templates
	fi
}


install_orm()
{
	install_module "orm" "https://github.com/kohana/orm.git"

	if [ "$INSTALL" == "y" ];
	then
		echo "[!!] You will need the database module in order to use ORM"
		install_db
	fi
}

install_db()
{
	install_module "database" "https://github.com/kohana/database.git"

	if [ "$INSTALL" == "y" ];
	then
		cp modules/database/config/database.php application/config/database.php
	fi
}

install_kostache
install_orm
install_db

# Ensure submodules initialised
echo "Initialising submodules..."
git submodule update --init  > /dev/null

# Add changes
git add . > /dev/null

echo "Please provide a commit message or leave blank to use default: "
read COMMIT

if [ ! -n "$COMMIT" ];
then
	COMMIT="Kohana Application Installer run for $APP_NAME"
fi

echo "Commiting original sin...." 
git commit -m "$COMMIT" > /dev/null

echo "Done."
