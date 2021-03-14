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

function Test-ParentImage {
    return Test-Path "$($env:IMAGEDRIVE)win10-PARENT.vhdx" 
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
Write-Host "Festplatte wird geleert"
# Clean
Clear-Disk -RemoveData -RemoveOEM -Number 0 -Confirm:$false | Out-Null
# Intitalize
Initialize-Disk -Number 0 -PartitionStyle GPT | Out-Null


### Prepare partitions
Write-Host "Partitionen werden vorbereitet"
# Create EFI/Boot partition
New-Partition -DiskNumber 0 -Size 300MB -DriveLetter S -GptType "{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}" | Out-Null
# Format FAT32
Format-Volume -DriveLetter S -FileSystem FAT32 -NewFileSystemLabel "BOOT" | Out-Null

# Create MSR
New-Partition -DiskNumber 0 -Size 128MB -GptType "{e3c9e316-0b5c-4db8-817d-f92df00215ae}" | Out-Null

# Create RESETOS partition
New-Partition -DiskNumber 0 -Size 4GB -DriveLetter R | Out-Null
# if (Test-Path -Path "$($env:IMAGEDRIVE)resetos.wim") {
#     # Format NTFS
#     Format-Volume -DriveLetter R -FileSystem NTFS -NewFileSystemLabel "ResetOS"
#     # Expand reset image
#     Expand-WindowsImage -ImagePath "$($env:IMAGEDRIVE)resetos.wim" -Index 1 -ApplyPath R:\
#     # Enable boot
#     & cmd /c "R:\windows\system32\bcdboot.exe R:\Windows /s S:"
# }

# Create Pagefile partition
New-Partition -DiskNumber 0 -Size 4GB -DriveLetter P | Out-Null
# Format NTFS
Format-Volume -DriveLetter P -FileSystem NTFS -NewFileSystemLabel "PageFile" | Out-Null

# Create Work partition
New-Partition -DiskNumber 0 -UseMaximumSize -DriveLetter W | Out-Null
# Format NTFS
Format-Volume -DriveLetter W -FileSystem NTFS -NewFileSystemLabel "Images" | Out-Null


## Copy Image File
Write-Host "Parent-Image wird kopiert"
if (Test-ParentImage) {
    Write-Host -ForegroundColor Black -BackgroundColor Yellow "Imagedatei wird vom Stick kopiert. Bitte warten..."
    # Copy file from ResetStick
    Copy-Item -Verbose -Path "$($env:IMAGEDRIVE)win10-PARENT.vhdx" -Destination W:\
} else {
    Write-Host -ForegroundColor Black -BackgroundColor Yellow "Imagedatei wird vom Netzwerk kopiert. Bitte warten..."
    # SMB Connection
    New-SmbMapping -LocalPath N: -RemotePath \\Timago\WindowsReset$ -UserName "test\winreset" -Password "Unsecure1!" | Out-Null
    # Copy VHDX
    Copy-Item -Verbose -Path N:\win10-PARENT.vhdx -Destination W:\
}

## Mount Parent VHDX
& diskpart /s "$($env:IMAGEDRIVE)Mount-VirtualDisk-Parent.diskpart" | Out-Null

### Create Boot Entry
Write-Host "Booteinträge werden erstellt."
V:\Windows\System32\bcdboot.exe V:\Windows /s S: /f UEFI