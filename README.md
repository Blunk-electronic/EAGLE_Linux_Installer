# EAGLE_Linux_Installer
A guide on how to install Eagle on Linux (verified on OpenSuse Tumbleweed)

## The problem
There is still no proper installer provided by Autodesk for version 9.x as we knew it from earlier versions.
One has to unpack a tag.gz archive and has to copy it where one pleases. From my point of view 
this is a non-professional way to install software as it implies issues when installing as root
in /opt/ for example:

- If you do that as non-root user, there is not much to fix: 
  After unpacking change into directory eagle-9.2.0/lib and delete all files starting with libxcb*.
  If the executable "eagle" in eagle-9.2.0 is started, everything should work fine (make sure this
  stuff is installed: libx11-xcb1, libxcb-dri2-0, libxcb-dri3-0, libxcb-glx0, libxcb-present0, libxcb-sync1,
  libxcb-xfixes0. 
  see also https://forums.autodesk.com/t5/eagle-forum/can-t-run-eagle-on-debian-10-testing/td-p/8312348).
  
- If you want to install it as root in /opt for example, there is a lot to be fixed. 
  Important when unpacking the tar file is the option --no-same-owner. Otherwise you get the files unpacked 
  with the root user id 501, which is definitely no root user id. Further-on lots of file permissions are
  way to restrictive so that the non-root user is unable to start Eagle. 
  I made things probably unnecessary labor-some but it finally worked and I have got no other idea how to
  solve the issues. I did this procedure under OpenSuse Tumbleweed: 
  First copy the archive file in /opt . Then proceed as follows:

## The solution step by step

Login as root. Observe the follwing instructions carefully in order not to mess up your machine.

Unpack the gz archive:
```sh
$ gunzip Autodesk_EAGLE_9.2.2_English_Linux_64bit.tar.gz
```
  
Unpack the tar archive:
```sh
$ tar --no-same-owner -xf Autodesk_EAGLE_9.2.2_English_Linux_64bit.tar 
```

Change the Eagle install directory permissions so that non-root users may enter and read it:
```sh
chmod 755 eagle-9.2.2
```

Change into the Eagle install directory:
```sh
cd eagle-9.2.2/
```

All files there must have the r (readable) flag set so that also non-root users can open and read them:
```sh
chmod -R a+r *
```

Change the Eagle executable so that non-root users may launch it:
```sh
chmod a+x eagle
```

All directories must be readable by all users. so that non-root users can change into them:
```sh
find . -type d -exec chmod a+x {} \;
```

Remove all files starting with 'libxcb' in the subdirectory 'lib'
```sh
rm lib/libxcb*
```

The remaining libraries there must be set executable for non-root users. 
I'm not sure if all files require this setting but this way all of them are addressed:
```sh
chmod 755 lib/*
```

Change permissions of Qt stuff:
```sh
chmod 755 libexec/QtWebEngineProcess
```

Now you can launch Eagle as non-root user. Make sure the $PATH environment variable is set properly.


## The smart solution via an install script
Here is the more comfortable install script install-eagle.sh.

<!--<div class="alert alert-block alert-danger"><b>CAUTION:
</b>YOU RUN THIS SCRIPT ON YOUR OWN RISK !</div>
<br/>-->
**WARNING:**
- YOU LAUNCH THIS SCRIPT ON YOUR OWN RISK !!
- You must be Root !
- Make sure you have a backup of directory /opt !!

It requires as arguments first the name of the install file and second
the version number.
The script will install Eagle in directory /opt !

Example on how to launch the installer:

```sh
sh install-eagle Autodesk_EAGLE_9.6.2_English_Linux_64bit.tar.gz 9.6.2
```

Finally set the PATH variable of your system so that all users can launch Eagle.
For a system wide setting create an empty file profile.local in /etc and
paste this line in it:

```sh
PATH=$PATH:/opt/eagle-9.6.2
```

Log off and on so that the new path setting takes effect.


## Set up the desktop icon
The script install-desktop-icons does the job. It must be launched by
the non-root user who wants to have the icon on her desktop. It requires
as argument the Eagle version like 9.6.2 :

```sh
sh install-desktop-icons.sh 9.6.2
```



