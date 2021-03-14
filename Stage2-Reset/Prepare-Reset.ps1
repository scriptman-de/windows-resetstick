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
Write-Host "Partitionen mounten"
# Remove all drive letters and assign corret letters
. "$($env:IMAGEDRIVE)Mount-EnvPartitions.ps1"

# Create Child VHD
Write-Host "Prüfe vorhandenen Child"
if (Test-Path -Path "W:\win10-CHILD.vhdx") {
    Write-Host "Vorhandenen Child gefunden. Wird entfernt!"
    Remove-Item -Path "W:\win10-CHILD.vhdx"
}
Write-Host "Neuer Child wird erstellt und eingebunden"
& diskpart /s "$($env:IMAGEDRIVE)\Create-VirtualDisk-Child.diskpart"
# Mount Child
& diskpart /s "$($env:IMAGEDRIVE)\Mount-VirtualDisk-Child.diskpart"

# Remove Parent boot entry
Write-Host "Booteinträge werden erstellt"
Remove-Item -Path S:\* -Filter * -Recurse -Force

# Create child boot entry
V:\Windows\System32\bcdboot.exe V:\Windows /s S: /f UEFI

# Create reset boot entry
& "$($env:IMAGEDRIVE)\Create-ResetBootEntry.cmd"

# Hide Partitions
Write-Host "Partitionierung wird angepasst"
& diskpart /s "$($env:IMAGEDRIVE)Hide-Partitions.diskpart"