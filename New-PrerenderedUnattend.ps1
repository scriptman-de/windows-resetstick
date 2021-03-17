$jsonReq = Invoke-RestMethod -Uri "http://localhost:3000/api/v1/enabled" -Method GET -ErrorAction SilentlyContinue

if (-Not $jsonReq.success) {
    Write-Host -ForegroundColor Red "Request war nicht erfolgreich!"
    Exit
}

$unattendPath = "$PSScriptRoot\Stage1-Prepare\unattendFiles"
$testpath = Test-Path $unattendPath
if (-Not $testpath) {
    New-Item -ItemType Directory -Path $unattendPath
}

foreach ($computer in $jsonReq.computers) {
    if (Test-Path "$unattendPath\unattend-$($computer.serial).xml") {
        Write-Host -ForegroundColor Yellow "Unattended für $($computer.name): $($computer.serial) ist schon vorhanden."
    }
    else {
        Write-Host "Hole Unattended für $($computer.name): $($computer.serial)"
        Invoke-RestMethod -Uri "http://setuphelper/api/v1/unattend?serial=$($computer.serial)" -Method GET -OutFile "$unattendPath\unattend-$($computer.serial).xml"
    }
}