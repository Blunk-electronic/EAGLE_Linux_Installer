#! /bin/bash

installer=$1
version=$2
target_dir=/opt

proc_confirmation()
	{
	read -p "Press ENTER to continue. Otherwise press CTRL-C to abort. "
	}

echo "installing EAGLE" $version to target directory $target_dir "..."
proc_confirmation

echo "unzipping the install file" $installer "..."
# unpack without warning. Keep installer file.
gunzip --force -k $installer

installer=${installer%.gz}
echo "unpacking the tape archive" $installer to target directory $target_dir "..."
tar --warning none --no-same-owner -xf $installer -C $target_dir

# clean up
rm *.tar



# change to target directory
cd $target_dir

echo "setting permissions ..."

# Change permissions so that non-root users may enter and read it:
chmod 755 eagle-$version

# change into the eagle install directory
cd eagle-$version

# All files there must have the r (readable) flag set so that also non-root
# users can open and read them:
chmod -R a+r *

# Change the Eagle executable so that non-root users may launch it:
chmod a+x eagle

# All directories must be readable by all users. so that non-root users
# can change into them:
find . -type d -exec chmod a+x {} \;

# Remove all files starting with 'libxcb' in the subdirectory 'lib'
rm lib/libxcb*

# The remaining libraries there must be set executable for non-root 
# users. I'm not sure if all files require this setting but this way all
# of them are addressed:
chmod 755 lib/*

# Change permissions of Qt stuff:
chmod 755 libexec/QtWebEngineProcess

echo "Installation complete. Please adjust PATH variable."

exit
