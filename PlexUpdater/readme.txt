This shell script was written for Ubunutu and may need to be customized for your flavor of linux.

It was written to download & install updates to Plex Media Server (PMS) for an existing installation on my Ubuntu server.

You will need to have a working installation of PMS to get your download link, then set it up as a cron job as root to regularly check for updates.

For details, check my blog at http://thephuck.com/scripts/automatic-plex-media-server-update-script-for-linuxubuntu/

cron setup:
0 6 * * 2,5 /usr/bin/screen -x dpkginstall -X stuff "/root/dl_plex.sh \015"

You can reattach to the screen by running "screen -r dpkginstall" to see the output, and then ctrl+a d to detach from the screen session.
