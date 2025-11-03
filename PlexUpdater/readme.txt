** updated Nov 3, 2025 **

This script will download the .deb file and compare it to the currently running version of PMS, and install if newer, but only if nothing is being played.

You will need to get your token and add it to the plex_token variable.

Use cron to run it, but run it in screen, like this:

/usr/bin/screen -x dpkginstall -X stuff "/root/dl_plex.sh \015"

This has been working for years on my server, and you can connect to the screen session by running:

screen -list
screen -r [session]

To disconnect without closing the screen session, hit CTRL+A then D

Here's mine as an example:
screen -list
There is a screen on:
        907.dpkginstall (06/21/2025 10:14:20 PM)        (Detached)
1 Socket in /run/screen/S-root.

Then I run "screen -r 907.dpkginstall" to reconnect and check logs.

** Old version below **
This shell script was written for Ubunutu and may need to be customized for your flavor of linux.

It was written to download & install updates to Plex Media Server (PMS) for an existing installation on my Ubuntu server.

You will need to have a working installation of PMS to get your download link, then set it up as a cron job as root to regularly check for updates.

For details, check my blog at http://thephuck.com/scripts/automatic-plex-media-server-update-script-for-linuxubuntu/

cron setup:
0 6 * * 2,5 /usr/bin/screen -x dpkginstall -X stuff "/root/dl_plex.sh \015"

You can reattach to the screen by running "screen -r dpkginstall" to see the output, and then ctrl+a d to detach from the screen session.

I also keep all previous version.  This saved me, as I discovered a bug in a version and was able to notify Plex which specific version the bug was introduced.
