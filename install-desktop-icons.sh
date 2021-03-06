#! /bin/bash

version=$1

echo "installing EAGLE desktop icon" $version "..."

icon=$HOME/Desktop/EAGLE_$version.desktop

if [ -e $icon ]; then
	{
	echo "removing old icon ..."
	rm $icon
	}
fi
	
echo [Desktop Entry] >> $icon
echo Version=1.0 >> $icon
echo Type=Application >> $icon
echo Name=EAGLE_$version >> $icon
echo Comment= >> $icon
echo Exec=eagle >> $icon
echo Icon=/opt/eagle-$version/bin/eagle-logo.png >> $icon
echo Path= >> $icon
echo Terminal=false >> $icon
echo StartupNotify=false >> $icon


exit
