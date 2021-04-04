function Get-ImageVolume {
    $drives = Get-PSDrive -PSProvider "FileSystem"
    
    foreach ($drive in $drives) {
        if (Test-Path "$($drive.Root)PREPAREDISK.MRK") {
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
Write-Host "============================================================"
Write-Host ""


$env:IMAGEDRIVE = Get-ImageVolume

Write-Host -BackgroundColor Yellow -ForegroundColor Black "Windows ResetStick ist Volume $env:IMAGEDRIVE"

if($null -ne $env:IMAGEDRIVE) {
    Write-Host "Lösche alte Scripte"
    # Delete "old" scripts
    Remove-Item -Path $env:IMAGEDRIVE\*.ps1 -Recurse
    Remove-Item -Path $env:IMAGEDRIVE\*.diskpart -Recurse
    Remove-Item -Path $env:IMAGEDRIVE\unattendFiles -Recurse -ErrorAction SilentlyContinue

    Write-Host "Kopiere Powershell Scripte"
    # scripts
    Copy-Item -Path .\Stage1-Prepare\*.ps1 -Destination $env:IMAGEDRIVE
    Copy-Item -Path .\Stage1-Prepare\*.diskpart -Destination $env:IMAGEDRIVE

    #prerendered unattend
    if (Test-Path .\Stage1-Prepare\unattendFiles) {
        Write-Host "Kopiere vorhandede Unattend-Dateien"
        New-Item -ItemType Directory -Path $env:IMAGEDRIVE\unattendFiles -ErrorAction SilentlyContinue
        Copy-Item -Path .\Stage1-Prepare\unattendFiles\*.xml -Destination $env:IMAGEDRIVE\unattendFiles
    }

    Write-Host "Kopiere ResetOS.wim"
    # Diskpart scripts
    Copy-Item -Path .\ResetOS.wim -Destination $env:IMAGEDRIVE -Force

    $marker = Test-Path "$($env:IMAGEDRIVE)IMAGEDRIVE.MRK"
    if (-Not $marker) {
        New-Item -Type File -Path $env:IMAGEDRIVE -Name "IMAGEDRIVE.MRK"
    }
    
    Write-Host -ForegroundColor Black -BackgroundColor Green "Fertig!"
}