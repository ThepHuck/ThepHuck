# Automatic Plex Media Server Update Script (Linux / Ubuntu)

For details, see the blog post:
[http://thephuck.com/scripts/automatic-plex-media-server-update-script-for-linuxubuntu/](http://thephuck.com/scripts/automatic-plex-media-server-update-script-for-linuxubuntu/)

---

## What it does

* Downloads the Plex `.deb` package.
* Compares the downloaded version to the currently running Plex Media Server (PMS) version.
* Installs the downloaded package **only if** the downloaded version is newer **and** nothing is currently being streamed.
* Keeps previous versions (handy for rolling back when a new release introduces a bug).

---

## Requirements

* Linux / Ubuntu
* `curl` / `wget` (curl for streams, wget to download the package)
* `screen`
* Root privileges (add to root's cron to install the `.deb`)
* Your Plex token — add it to the `plex_token` variable in the script

---

## Cron + Screen setup

Run the script from a `screen` session via `cron` so output is retained and inspectable.

Example `cron` entry (runs at 06:00 on Tuesdays and Fridays):

```cron
0 6 * * 2,5 /usr/bin/screen -x dpkginstall -X stuff "/root/dl_plex.sh \015"
```

This attaches the command to a screen session named `dpkginstall`. To view or reattach:

```bash
# list active screen sessions
screen -list

# reattach to the dpkginstall session
screen -r dpkginstall

# detach from the session (when inside screen)
Ctrl + A, then D
```

Example `screen -list` output:

```
There is a screen on:
        907.dpkginstall (06/21/2025 10:14:20 PM)        (Detached)
1 Socket in /run/screen/S-root.
```

---

## Example: Update run (when an update is available)

```
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
Resolving downloads.plex.tv (downloads.plex.tv)... 104.18.36.51, 172.64.151.205, ...
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
PlexMediaServer install: Pre-installation Validation complete.
Unpacking plexmediaserver (1.42.2.10156-f737b826c) over (1.42.1.10060-4e8b05daf) ...
Setting up plexmediaserver (1.42.2.10156-f737b826c) ...
PlexMediaServer install: PlexMediaServer-1.42.2.10156-f737b826c - Installation successful.  Errors: 0, Warnings: 0
Processing triggers for mime-support (3.64ubuntu1) ...
#
# renaming downloaded package to plex.1.42.2.10156.deb
#
###########################
```

---

## Example: No update (downloaded version is same as installed)

```
###########################
#
# Mon 03 Nov 2025 07:52:03 PM CST
#
# Checking if any movies are being watched
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    83  100    83    0     0  27666      0 --:--:-- --:--:-- --:--:-- 27666
#
# No movies are currently being streamed
#
# downloading plex.deb
--2025-11-03 19:52:03--  https://plex.tv/downloads/latest/1?channel=16&build=linux-ubuntu-x86_64&distro=ubuntu
Resolving plex.tv (plex.tv)... 34.238.225.186, 35.172.142.61, 44.210.41.33
Connecting to plex.tv (plex.tv)|34.238.225.186|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://downloads.plex.tv/plex-media-server-new/1.42.2.10156-f737b826c/debian/plexmediaserver_1.42.2.10156-f737b826c_amd64.deb [following]
--2025-11-03 19:52:03--  https://downloads.plex.tv/plex-media-server-new/1.42.2.10156-f737b826c/debian/plexmediaserver_1.42.2.10156-f737b826c_amd64.deb
Resolving downloads.plex.tv (downloads.plex.tv)... 172.64.151.205, 104.18.36.51, 2a06:98c1:3103::6812:2433, ...
Connecting to downloads.plex.tv (downloads.plex.tv)|172.64.151.205|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 83123046 (79M) [application/vnd.debian.binary-package]
Saving to: ‘/root/plex.deb’

/root/plex.deb                             100%[======================================================================================>]  79.27M  25.7MB/s    in 3.1s

2025-11-03 19:52:06 (25.7 MB/s) - ‘/root/plex.deb’ saved [83123046/83123046]

#
# comparing versions
# currently installed version is 1.42.2.10156
# downloaded version is 1.42.2.10156
#
# 1.42.2.10156 is not greater than 1.42.2.10156
# deleting downloaded package
#
###########################
```

---

## Notes

* Insert your Plex token into the `plex_token` variable in the script before running.
* Running in `screen` preserves output for inspection and troubleshooting.
* Keeping previous versions allowed me to identify a bug and report the exact version it was introduced in — consider keeping the same retention behavior.
* Ensure the script has executable permissions and is run with sufficient privileges in root's cron to install `.deb` packages:

```bash
chmod +x /root/dl_plex.sh
```
