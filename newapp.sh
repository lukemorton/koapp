# Grab the Vitals.
#
# You will need installed:
#
#    * git
#    * apache ( + mod_php )
#

# Request application name
echo "Please provide a path in which to install your new Kohana application: "
read APP_NAME

if [ ! -n "$APP_NAME" ];
then
	APP_NAME = ~/koapp
fi

# Create folder in application path and change into it
echo "Creating application path..."
mkdir -p $APP_NAME
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
git submodule add https://github.com/kohana/core.git system > /dev/null

# Install Kostache?
echo "Would you like to install Kostache?"
read KOSTACHE

if [ $KOSTACHE == 'y' ];
then
	# Install Kostache
	echo "Cloning zombor's Kostache into system..."
	git submodule add https://github.com/zombor/KOstache.git modules/kostache > /dev/null
	mkdir application/templates
fi

# Ensure submodules initialised
echo "Initialising submodules..."
git submodule update --init

# Commit changes
echo "Commiting original sin...." 
git add . 
git commit -m "My base Kohana setup for $APP_NAME"

echo "Done."
