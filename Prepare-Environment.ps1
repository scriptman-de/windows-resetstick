function Get-ImageVolume {
    $drives = Get-PSDrive -PSProvider "FileSystem"
    
    foreach ($drive in $drives) {
        if (Test-Path "$($drive.Root)IMAGEDRIVE.MRK") {
            return $drive.Root.ToString()
        }
    }

    # In case of PXE boot
    return "X:\Scripts\"
}


Clear-Host

Write-Host "============================================================"
Write-Host "= Windows 10 Education Reset Stick                         ="
Write-Host "= Umgebung wird vorbereitet                                ="
# Write-Host "=                                                          ="
Write-Host "============================================================"
Write-Host ""


$env:IMAGEDRIVE = Get-ImageVolume

### Prepare Disk 0
# Clean
Clear-Disk -RemoveData -RemoveOEM -Number 0 -Confirm:$false
# Intitalize
Initialize-Disk -Number 0 -PartitionStyle GPT


### Prepare partitions
# Create EFI/Boot partition
New-Partition -DiskNumber 0 -Size 300MB -DriveLetter S -GptType "{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}"
# Format FAT32
Format-Volume -DriveLetter S -FileSystem FAT32 -NewFileSystemLabel "BOOT"

# Create MSR
New-Partition -DiskNumber 0 -Size 128MB -GptType "{e3c9e316-0b5c-4db8-817d-f92df00215ae}"

# Create RESETOS partition
New-Partition -DiskNumber 0 -Size 4GB -DriveLetter R
# # Format NTFS
# Format-Volume -DriveLetter R -FileSystem NTFS -NewFileSystemLabel "ResetOS"
# # Expand reset image
# if (Test-Path -Path "$($env:IMAGEDRIVE)resetos.wim") {
#     Expand-WindowsImage -ImagePath "$($env:IMAGEDRIVE)resetos.wim" -Index 1 -ApplyPath R:\
#     # Enable boot
#     & cmd /c "R:\windows\system32\bcdboot.exe R:\Windows /s S:"
# }

# Create Pagefile partition
New-Partition -DiskNumber 0 -Size 4GB -DriveLetter P
# Format NTFS
Format-Volume -DriveLetter P -FileSystem NTFS -NewFileSystemLabel "PageFile"

# Create Work partition
New-Partition -DiskNumber 0 -UseMaximumSize -DriveLetter W
# Format NTFS
Format-Volume -DriveLetter W -FileSystem NTFS -NewFileSystemLabel "Images"


### Copy Image File From Timago Server
# SMB Connection
New-SmbMapping -LocalPath N: -RemotePath \\Timago\WindowsReset$ -UserName "test\lra-djoin" -Password "Unsecurep@55w0rd!"
# Copy VHDX
Copy-Item -Path N:\win10-PARENT.vhdx -Destination W:\

### Mount Parent VHDX
& diskpart /s "$($env:IMAGEDRIVE)Mount-VirtualDisk-Parent.diskpart"

### Create Boot Entry
V:\Windows\System32\bcdboot.exe V:\Windows /s S: /f UEFI

### Enable Setup
& "$($env:IMAGEDRIVE)Enable-Unattend.ps1"