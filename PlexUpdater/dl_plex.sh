#!/bin/bash
echo "###########################"
echo "#"
echo "# $(date)"
echo "#"
echo "# Checking if any movies are being watched"
sessions=$(curl http://127.0.0.1:32400/status/sessions?X-Plex-Token=Removed | grep "MediaContainer size" | awk -F'[\"]' '{print $2}')
if (($sessions < 1))
then
echo "#"
echo "# No movies are currently being streamed"
echo "#"
echo "# downloading plex.deb"
#
# release
wget -O /root/plex.deb "https://plex.tv/downloads/latest/1?channel=16&build=linux-ubuntu-x86_64&distro=ubuntu&X-Plex-Token=Removed"
# beta url
#wget -O /root/plex.deb "https://plex.tv/downloads/latest/5?channel=8&build=linux-x86_64&distro=debian&X-Plex-Token=Removed"
echo "#"
echo "# comparing versions"
newplex="$(dpkg -I /root/plex.deb | grep Version | awk '{print $2}' | awk -F'[ -]' '{print $1}')"
currentplex="$(dpkg -l | grep plexmediaserver | awk '{print $3}' | awk -F'[ -]' '{print $1}')"
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
