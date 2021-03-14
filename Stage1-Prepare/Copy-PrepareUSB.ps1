function Get-ImageVolume {
    $drives = Get-PSDrive -PSProvider "FileSystem"
    
    foreach ($drive in $drives) {
        if (Test-Path "$($drive.Root)IMAGEDRIVE.MRK") {
            return $drive.Root.ToString()
        }
    }

    Write-Host -BackgroundColor Red -ForegroundColor Black "ResetStick konnte nicht gefunden werden!"
    return $null
}

Clear-Host

Write-Host "============================================================"
Write-Host "= Windows 10 Education Reset Stick                         ="
Write-Host "= Scripts werden auf ResetStick kopiert                    ="
# Write-Host "=                                                          ="
Write-Host "============================================================"
Write-Host ""


$env:IMAGEDRIVE = Get-ImageVolume

Write-Host -BackgroundColor Yellow -ForegroundColor Black "Windows ResetStick ist Volume $env:IMAGEDRIVE"

if($null -ne $env:IMAGEDRIVE) {
    Write-Host "Lösche alte Scripte"
    # Delete "old" scripts
    Remove-Item -Path $env:IMAGEDRIVE\*.ps1 -Recurse
    Remove-Item -Path $env:IMAGEDRIVE\*.diskpart -Recurse

    Write-Host "Kopiere Powershell Scripte"
    # Powershell scripts
    Copy-Item -Path .\RunScripts.ps1 $env:IMAGEDRIVE
    Copy-Item -Path .\Prepare-Environment.ps1 $env:IMAGEDRIVE
    Copy-Item -Path .\Prepare-Reset.ps1 $env:IMAGEDRIVE
    Copy-Item -Path .\Enable-Unattend.ps1 $env:IMAGEDRIVE
    Copy-Item -Path .\Get-UnattendedFile.ps1 $env:IMAGEDRIVE
    Copy-Item -Path .\Connect-NetworkShare.ps1 $env:IMAGEDRIVE

    Write-Host "Kopiere Diskpart Scripte"
    # Diskpart scripts
    Copy-Item -Path .\Hide-Partitions.diskpart $env:IMAGEDRIVE
    Copy-Item -Path .\Create-VirtualDisk-Child.diskpart $env:IMAGEDRIVE
    Copy-Item -Path .\Mount-Env-Partitions.diskpart $env:IMAGEDRIVE
    Copy-Item -Path .\Mount-VirtualDisk-Parent.diskpart $env:IMAGEDRIVE
    Copy-Item -Path .\Mount-VirtualDisk-Child.diskpart $env:IMAGEDRIVE

    # Write-Host "Kopiere boot.wim"
    # Copy-Item -Path .\WinPE_amd64_ResetChild\media\sources\boot.wim $env:IMAGEDRIVE\sources
    # Copy-Item -Path .\Create-ResetBootEntry.cmd -Destination $env:IMAGEDRIVE
    
    Write-Host -ForegroundColor Black -BackgroundColor Green "Fertig!"
}