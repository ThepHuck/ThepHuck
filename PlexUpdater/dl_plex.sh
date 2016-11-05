#!/bin/bash
plextoken="removed"
logpath="/var/log/plex_updater.log"
{
echo "###########################"
echo "#"
echo "# $(date)"
echo "#"
echo "# Checking if any movies are being watched"
sessions=$(curl -s http://127.0.0.1:32400/status/sessions?X-Plex-Token=$plextoken | grep "MediaContainer size" | awk -F'[\"]' '{print $2}')
if (($sessions < 1))
then
echo "#"
echo "# No movies are currently being streamed"
echo "#"
echo "# downloading plex.deb"
wget -O /root/plex.deb "https://plex.tv/downloads/latest/1?channel=8&build=linux-ubuntu-x86_64&distro=ubuntu&X-Plex-Token=$plextoken"
echo "#"
echo "# comparing versions"
newplex="$(dpkg-deb -f /root/plex.deb Version)"
currentplex="$(dpkg-query --show -f='${Version}' plexmediaserver)"
echo "# currently installed version is $currentplex"
echo "# downloaded version is $newplex"
/usr/bin/dpkg --compare-versions $newplex gt $currentplex
if (($? < 1))
then
        echo "#"
        echo "# $newplex is greater than $currentplex"
        echo "# installing downloaded plex"
        echo "#"
        /usr/bin/dpkg -i /root/plex.deb
        echo "#"
        echo "# renaming downloaded package to plex.$newplex.deb"
        mv /root/plex.deb /root/plex.$newplex.deb
        echo "#"
else
        echo "#"
        echo "# $newplex is not greater than $currentplex"
        echo "# deleting downloaded package"
        rm plex.deb
fi
else
echo "#"
echo "# A movie is currently being streamed, will not check on upgrade"
fi
echo "#"
echo "###########################"
} >> $logpath
