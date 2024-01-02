# new-nvmeDisk
# written by @ThepHuck
# 
# To-Do: check for existing disks attached to the NVMe controller and add after last one

param(
    [Parameter(Mandatory)][String]$VM,
    [Parameter(Mandatory)][Int]$NumberOfDisks,
    [Parameter(Mandatory)][Int]$DiskSizeGB
)

# Need some script-wide variables
Set-Variable -name vmView -scope script
Set-Variable -name DiskSizeKB -scope script -value ($DiskSizeGB*1024*1024)
Set-Variable -name DiskSizeB -scope script -value ($DiskSizeKB*1024)
Set-Variable -name controllerKey -scope script

function addController{
    $script:vmView = $node | Get-View
    $nvmeSpec = $null
    $nvmeSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
    $nvmeSpec.DeviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec[] (1)
    $nvmeSpec.DeviceChange[0] = New-Object VMware.Vim.VirtualDeviceConfigSpec
    $nvmeSpec.DeviceChange[0].Device = New-Object VMware.Vim.VirtualNVMEController
    $nvmeSpec.DeviceChange[0].Device.DeviceInfo = New-Object VMware.Vim.Description
    $nvmeSpec.DeviceChange[0].Device.DeviceInfo.Summary = 'New NVMe Controller'
    $nvmeSpec.DeviceChange[0].Device.DeviceInfo.Label = 'New NVMe Controller'
    $nvmeSpec.DeviceChange[0].Device.Key = -102
    $nvmeSpec.DeviceChange[0].Device.BusNumber = 0
    $nvmeSpec.DeviceChange[0].Operation = 'add'
    $nvmeSpec.VirtualNuma = New-Object VMware.Vim.VirtualMachineVirtualNuma
    $controllerTask = $script:vmView.ReconfigVM_Task($nvmeSpec)
    $controllertaskID = $controllerTask.type + "-" + $controllerTask.Value
    sleep 2
    if((Get-Task -Id $controllertaskID).State -notmatch "Success"){write-host "Check the host client UI, task was not successful"}
    else{write-host "NVMe controller added successfully!"}
}

function addDisks{
    param(
        [Parameter(Mandatory)][Int]$UnitNumber
    )
    write-host "Adding NVMe disk" $UnitNumber
    $diskTask = $null
    $vDiskSpec = $null
    $vDiskSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
    $vDiskSpec.DeviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec[] (1)
    $vDiskSpec.DeviceChange[0] = New-Object VMware.Vim.VirtualDeviceConfigSpec
    $vDiskSpec.DeviceChange[0].FileOperation = 'create'
    $vDiskSpec.DeviceChange[0].Device = New-Object VMware.Vim.VirtualDisk
    $vDiskSpec.DeviceChange[0].Device.CapacityInBytes = $script:DiskSizeB
    $vDiskSpec.DeviceChange[0].Device.StorageIOAllocation = New-Object VMware.Vim.StorageIOAllocationInfo
    $vDiskSpec.DeviceChange[0].Device.StorageIOAllocation.Shares = New-Object VMware.Vim.SharesInfo
    $vDiskSpec.DeviceChange[0].Device.StorageIOAllocation.Shares.Shares = 1000
    $vDiskSpec.DeviceChange[0].Device.StorageIOAllocation.Shares.Level = 'normal'
    $vDiskSpec.DeviceChange[0].Device.StorageIOAllocation.Limit = -1
    $vDiskSpec.DeviceChange[0].Device.Backing = New-Object VMware.Vim.VirtualDiskFlatVer2BackingInfo
    $vDiskSpec.DeviceChange[0].Device.Backing.FileName = ''
    $vDiskSpec.DeviceChange[0].Device.Backing.EagerlyScrub = $false
    $vDiskSpec.DeviceChange[0].Device.Backing.ThinProvisioned = $true
    $vDiskSpec.DeviceChange[0].Device.Backing.DiskMode = 'persistent'
    $vDiskSpec.DeviceChange[0].Device.ControllerKey = $script:controllerKey
    $vDiskSpec.DeviceChange[0].Device.UnitNumber = $UnitNumber
    $vDiskSpec.DeviceChange[0].Device.CapacityInKB = $script:DiskSizeKB
    $vDiskSpec.DeviceChange[0].Device.DeviceInfo = New-Object VMware.Vim.Description
    $vDiskSpec.DeviceChange[0].Device.DeviceInfo.Summary = 'New Hard disk'
    $vDiskSpec.DeviceChange[0].Device.DeviceInfo.Label = 'New Hard disk'
    $vDiskSpec.DeviceChange[0].Device.Key = -102
    $vDiskSpec.DeviceChange[0].Operation = 'add'
    $vDiskSpec.VirtualNuma = New-Object VMware.Vim.VirtualMachineVirtualNuma
    $diskTask = $script:vmView.ReconfigVM_Task($vDiskSpec)
    sleep 2
    if((Get-Task -Id $diskTask).State -notmatch "Success"){write-host "Check the host client UI, task was not successful"}
    else{write-host "Disk added successfully!"}
}

try{
    $node = get-vm $VM
    $script:vmView = $node | Get-View
}
catch  {
    write-host -fore red "I can't find the VM"
    exit 
}

#If we don't have an NVMe controller, create one
if(($script:vmView.config.hardware.device | ? {$_.deviceinfo.Label -match "NVME"}).count -eq 0){
    write-host "No NVMe controller present, adding!"
    addController
    }
else{
    write-host "NVMe controller found!"
}

#Get the NVMe controller's key
$script:controllerKey = ($script:vmView.config.hardware.device | ? {$_.deviceinfo.Label -match "NVME"}).Key

$DiskID = 0
do {
    addDisks -UnitNumber $DiskID
    $DiskID+=1
}
until ($DiskID -eq $NumberOfDisks)
