function Get-ImageVolume {
    $drives = Get-PSDrive -PSProvider "FileSystem"
    
    foreach ($drive in $drives) {
        if (Test-Path "$($drive.Root)IMAGEDRIVE.MRK") {
            return $drive.Root.ToString()
        }
    }

    # In case of PXE boot
    return "X:\"
}

Clear-Host

Write-Host "============================================================"
Write-Host "= Windows 10 Education Reset Stick                         ="
Write-Host "= Umgebung wird vorbereitet                                ="
Write-Host "============================================================"
Write-Host ""

$env:IMAGEDRIVE = Get-ImageVolume
Write-Host -ForegroundColor Black -BackgroundColor Yellow "Imagedrive ist $($env:IMAGEDRIVE)"

# test if the preredered unatteded file folder exists to skip web hook
$env:UNATTENDEDFOLDER = "$($env:IMAGEDRIVE)unattendFiles"
$env:UNATTED_AVAIL = Test-Path -Path $env:UNATTENDEDFOLDER

. "$($env:IMAGEDRIVE)Prepare-Environment.ps1"
. "$($env:IMAGEDRIVE)Enable-Unattend.ps1"
. "$($env:IMAGEDRIVE)Get-UnattendedFile.ps1"

Write-Host -ForegroundColor Black -BackgroundColor Green "Umgebung erstellt. Neu starten mit 'exit'"