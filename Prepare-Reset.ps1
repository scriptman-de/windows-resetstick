function Get-ImageVolume {
    $drives = Get-PSDrive -PSProvider "FileSystem"
    
    foreach ($drive in $drives) {
        if (Test-Path "$($drive.Root)IMAGEDRIVE.MRK") {
            return $drive.Root.ToString()
        }
    }

    return "X:\Scripts\"
}

Clear-Host

Write-Host "============================================================"
Write-Host "= Windows 10 Education Reset Stick                         ="
Write-Host "= ResetDisk wird vorbereitet                               ="
# Write-Host "=                                                          ="
Write-Host "============================================================"
Write-Host ""


$env:IMAGEDRIVE = Get-ImageVolume

### Mount Partitions
# Remove all drive letters and assign corret letters
& diskpart /s "$($env:IMAGEDRIVE)Mount-Env-Partitions.diskpart"

# Create Child VHD
if (Test-Path -Path "W:\win10-CHILD.vhdx") {
    Remove-Item -Path "W:\win10-CHILD.vhdx"
}
& diskpart /s "$($env:IMAGEDRIVE)\Create-VirtualDisk-Child.diskpart"
# Mount Child
& diskpart /s "$($env:IMAGEDRIVE)\Mount-VirtualDisk-Child.diskpart"

# Remove Parent boot entry
Remove-Item -Path S:\* -Filter * -Recurse -Force

# Create Child Boot Entry
V:\Windows\System32\bcdboot.exe V:\Windows /s S: /f UEFI

# Hide Partitions
& diskpart /s "$($env:IMAGEDRIVE)Hide-Partitions.diskpart"