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

# Create folder in application path and change into it
echo "Creating application path..."
mkdir -p $APP_NAME
cd $APP_NAME

# Create application folders with correct perms
echo "Creating application folders..."
mkdir {application,modules}
mkdir application/{classes,templates,public,cache,logs}
chmod 0777 application/cache application/logs

# Init repo
echo "Initialising application folder as git repo..."
git init > /dev/null

# Grab bootstrap and index
wget https://github.com/kohana/kohana/raw/3.1/master/application/bootstrap.php --output-file=application/bootstrap.php
wget https://github.com/kohana/kohana/raw/3.1/master/index.php --output-file=application/public/index.php

# Get system files
echo "Cloning Kohana Core into system..."
git submodule add https://github.com/kohana/core.git system > /dev/null

# Commit changes
echo "Commiting original sin...." 
git add . 
git commit -m "My base Kohana setup for $APP_NAME"

echo "Done."
