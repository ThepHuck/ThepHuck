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

Here's what you'll see when you connect to the screen session if there was an update:
###########################
#
# Mon 03 Nov 2025 06:04:13 PM CST
#
# Checking if any movies are being watched
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    83  100    83    0     0  83000      0 --:--:-- --:--:-- --:--:-- 83000
#
# No movies are currently being streamed
#
# downloading plex.deb
--2025-11-03 18:04:13--  https://plex.tv/downloads/latest/1?channel=16&build=linux-ubuntu-x86_64&distro=ubuntu
Resolving plex.tv (plex.tv)... 35.172.142.61, 44.210.41.33, 34.238.225.186
Connecting to plex.tv (plex.tv)|35.172.142.61|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://downloads.plex.tv/plex-media-server-new/1.42.2.10156-f737b826c/debian/plexmediaserver_1.42.2.10156-f737b826c_amd64.deb [following]
--2025-11-03 18:04:14--  https://downloads.plex.tv/plex-media-server-new/1.42.2.10156-f737b826c/debian/plexmediaserver_1.42.2.10156-f737b826c_amd64.deb
Resolving downloads.plex.tv (downloads.plex.tv)... 104.18.36.51, 172.64.151.205, 2a06:98c1:3103::6812:2433, ...
Connecting to downloads.plex.tv (downloads.plex.tv)|104.18.36.51|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 83123046 (79M) [application/vnd.debian.binary-package]
Saving to: ‘/root/plex.deb’

/root/plex.deb                             100%[======================================================================================>]  79.27M  19.5MB/s    in 4.6s

2025-11-03 18:04:18 (17.3 MB/s) - ‘/root/plex.deb’ saved [83123046/83123046]

#
# comparing versions
# currently installed version is 1.42.1.10060
# downloaded version is 1.42.2.10156
#
# 1.42.2.10156 is greater than 1.42.1.10060
# installing downloaded plex
#
(Reading database ... 163214 files and directories currently installed.)
Preparing to unpack /root/plex.deb ...
PlexMediaServer install: Pre-installation Validation.
PlexMediaServer install: Pre-installation Validation complete.
Unpacking plexmediaserver (1.42.2.10156-f737b826c) over (1.42.1.10060-4e8b05daf) ...
Setting up plexmediaserver (1.42.2.10156-f737b826c) ...
PlexMediaServer install: PlexMediaServer-1.42.2.10156-f737b826c - Installation starting.
PlexMediaServer install:
PlexMediaServer install: Now installing based on:
PlexMediaServer install:   Installation Type:   Update
PlexMediaServer install:   Process Control:     systemd
PlexMediaServer install:   Plex User:           plex
PlexMediaServer install:   Plex Group:          plex
PlexMediaServer install:   Video Group:         video
PlexMediaServer install:   Metadata Dir:        /var/lib/plexmediaserver/Library/Application Support
PlexMediaServer install:   Temp Directory:      /plex_tmp  (set in Preferences.xml)
PlexMediaServer install:   Lang Encoding:       en_US.UTF-8
PlexMediaServer install:   Processor:           Intel(R) Core(TM) i3-6100U CPU @ 2.30GHz
PlexMediaServer install:   Intel i915 Hardware: Found
PlexMediaServer install:   Nvidia GPU card:     Not Found
PlexMediaServer install:
PlexMediaServer install: Completing final configuration.
PlexMediaServer install: Starting Plex Media Server.
PlexMediaServer install: PlexMediaServer-1.42.2.10156-f737b826c - Installation successful.  Errors: 0, Warnings: 0
Processing triggers for mime-support (3.64ubuntu1) ...
#
# renaming downloaded package to plex.1.42.2.10156.deb
#
#
###########################

If it's the same version, you'll see this at the end:

# comparing versions
# currently installed version is 1.42.2.10156
# downloaded version is 1.42.2.10156
#
# 1.42.2.10156 is not greater than 1.42.2.10156
# deleting downloaded package
#
###########################

** Old version below **
This shell script was written for Ubunutu and may need to be customized for your flavor of linux.

It was written to download & install updates to Plex Media Server (PMS) for an existing installation on my Ubuntu server.

You will need to have a working installation of PMS to get your download link, then set it up as a cron job as root to regularly check for updates.

For details, check my blog at http://thephuck.com/scripts/automatic-plex-media-server-update-script-for-linuxubuntu/

cron setup:
0 6 * * 2,5 /usr/bin/screen -x dpkginstall -X stuff "/root/dl_plex.sh \015"

You can reattach to the screen by running "screen -r dpkginstall" to see the output, and then ctrl+a d to detach from the screen session.

I also keep all previous version.  This saved me, as I discovered a bug in a version and was able to notify Plex which specific version the bug was introduced.
