# Grab the Vitals.
#
# You will need installed:
#
#    * git
#    * apache ( + mod_php )
#

if [$APP_PATH == ""]
then
    # Use default application path
    APP_PATH = /var/www/
fi

# Request application name
echo "Please provide a name for your app (used as folder name under /var/www/): "
read APP_NAME

# Create folder in application path and change into it
mkdir -p $APP_PATH/$APP_NAME/
cd $APP_PATH/$APP_NAME/

# Create application folders with correct perms
mkdir {application,modules}
mkdir application/{classes,templates,public,cache,logs}
chmod 0777 application/cache application/logs

# Get system files
git submodule add https://github.com/kohana/core.git system

# Init repo
git init
git add .
git commit -m "My base Kohana setup for $APP_NAME"