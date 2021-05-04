### Mount Partitions
Write-Host "Partitionen mounten"
# Remove all drive letters and assign correct letters
& diskpart /s "$($env:IMAGEDRIVE)Mount-VirtualDisk-Parent.diskpart" | Out-Null

# Create Child VHD
Write-Host "Prüfe vorhandenen Child"
if (Test-Path -Path "W:\win10-CHILD.vhdx") {
    Write-Host "Vorhandenen Child gefunden. Wird entfernt!"
    Remove-Item -Path "W:\win10-CHILD.vhdx"
}
Write-Host "Parent wird eingebunden"
## Mount Parent VHDX
& diskpart /s "$($env:IMAGEDRIVE)Mount-VirtualDisk-Parent.diskpart" | Out-Null

### Create Boot Entry
# Remove boot entries
Write-Host "Booteinträge werden erstellt"
Remove-Item -Path S:\* -Filter * -Recurse -Force
# Create Parent boot entry
V:\Windows\System32\bcdboot.exe V:\Windows /s S: /f UEFI