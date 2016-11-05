#!/bin/bash
plextoken="removed"
logpath="/var/log/plex_updater.log"
echo "###########################" >> $logpath
echo "#" >> $logpath
echo "# $(date)" >> $logpath
echo "#" >> $logpath
echo "# Checking if any movies are being watched" >> $logpath
sessions=$(curl -s http://127.0.0.1:32400/status/sessions?X-Plex-Token=$plextoken | grep "MediaContainer size" | awk -F'[\"]' '{print $2}')
if (($sessions < 1))
then
echo "#" >> $logpath
echo "# No movies are currently being streamed" >> $logpath
echo "#" >> $logpath
echo "# downloading plex.deb" >> $logpath
wget -O /root/plex.deb "https://plex.tv/downloads/latest/1?channel=8&build=linux-ubuntu-x86_64&distro=ubuntu&X-Plex-Token=$plextoken" >> $logpath
echo "#" >> $logpath
echo "# comparing versions" >> $logpath
newplex="$(dpkg-deb -f /root/plex.deb Version)"
currentplex="$(dpkg-query --show -f='${Version}' plexmediaserver)"
echo "# currently installed version is $currentplex" >> $logpath
echo "# downloaded version is $newplex" >> $logpath
/usr/bin/dpkg --compare-versions $newplex gt $currentplex
if (($? < 1))
then
        echo "#" >> $logpath
        echo "# $newplex is greater than $currentplex" >> $logpath
        echo "# installing downloaded plex" >> $logpath
        echo "#" >> $logpath
        /usr/bin/dpkg -i /root/plex.deb >> $logpath
        echo "#" >> $logpath
        echo "# renaming downloaded package to plex.$newplex.deb" >> $logpath
        mv /root/plex.deb /root/plex.$newplex.deb
        echo "#" >> $logpath
else
        echo "#" >> $logpath
        echo "# $newplex is not greater than $currentplex" >> $logpath
        echo "# deleting downloaded package" >> $logpath
        rm plex.deb
fi
else
echo "#" >> $logpath
echo "# A movie is currently being streamed, will not check on upgrade" >> $logpath
fi
echo "#" >> $logpath
echo "###########################" >> $logpath
