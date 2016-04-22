#!/bin/bash
echo "###########################" >> /root/plex_downloader.log
echo "#" >> /root/plex_downloader.log
echo "# $(date)" >> /root/plex_downloader.log
echo "#" >> /root/plex_downloader.log
echo "# Checking if any movies are being watched" >> /root/plex_downloader.log
sessions=$(curl http://127.0.0.1:32400/status/sessions?X-Plex-Token=removed | grep "MediaContainer size" | awk -F'[\"]' '{print $2}')
if (($sessions < 1))
then
echo "#" >> /root/plex_downloader.log
echo "# No movies are currently being streamed" >> /root/plex_downloader.log
echo "#" >> /root/plex_downloader.log
echo "# downloading plex.deb" >> /root/plex_downloader.log
wget -O /root/plex.deb "https://plex.tv/downloads/latest/1?channel=16&build=linux-ubuntu-x86_64&distro=ubuntu&X-Plex-Token=removed" >> /root/plex_downloader.log
echo "#" >> /root/plex_downloader.log
echo "# comparing versions" >> /root/plex_downloader.log
newplex="$(dpkg -I /root/plex.deb | grep Version | awk '{print $2}' | awk -F'[ -]' '{print $1}')"
currentplex="$(dpkg -l | grep plexmediaserver | awk '{print $3}' | awk -F'[ -]' '{print $1}')"
echo "# currently installed version is $currentplex" >> /root/plex_downloader.log
echo "# downloaded version is $newplex" >> /root/plex_downloader.log
/usr/bin/dpkg --compare-versions $newplex gt $currentplex
if (($? < 1))
then
        echo "#" >> /root/plex_downloader.log
        echo "# $newplex is greater than $currentplex" >> /root/plex_downloader.log
        echo "# installing downloaded plex" >> /root/plex_downloader.log
        echo "#" >> /root/plex_downloader.log
        /usr/bin/dpkg -i /root/plex.deb >> /root/plex_downloader.log
        echo "#" >> /root/plex_downloader.log
        echo "# renaming downloaded package to plex.$newplex.deb" >> /root/plex_downloader.log
        mv /root/plex.deb /root/plex.$newplex.deb
        echo "#" >> /root/plex_downloader.log
else
        echo "#" >> /root/plex_downloader.log
        echo "# $newplex is not greater than $currentplex" >> /root/plex_downloader.log
        echo "# deleting downloaded package" >> /root/plex_downloader.log
        rm plex.deb
fi
else
echo "#" >> /root/plex_downloader.log
echo "# A movie is currently being streamed, will not check on upgrade" >> /root/plex_downloader.log
fi
echo "#" >> /root/plex_downloader.log
echo "###########################" >> /root/plex_downloader.log
