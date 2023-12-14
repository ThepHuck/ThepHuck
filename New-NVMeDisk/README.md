# New-NVMeDisk.ps1

## Purpose
I wrote this to be able to add NVMe disks directly to a VM in ESXi.

The script will add an NVMe controller if one does not exist.

It does not check for existing disks, that's on the to-do list.

## Syntax
First, connect directly to ESXi with `connect-viserver`

Then `new-nvmeDisk.ps1 -VM vmname -NumberOfDisks 4 -DiskSizeGB 500`

## Info
Tested on ESXi 8.0u1
