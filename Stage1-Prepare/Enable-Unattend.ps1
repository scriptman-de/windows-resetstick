if ($env:UNATTED_AVAIL -eq $true) {
    Write-Host -ForegroundColor Yellow "REST-Anfrage wird nicht durchgeführt. Vorgerenderte Unattend-Dateien sind vorhanden."
    Exit
}

# GET MAC ADDRESS
$mac = (Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true -and $_.DHCPEnabled -eq $true }).MACAddress

# GET Serial Number
$serial = (Get-CimInstance Win32_Bios).SerialNumber

# GET ComputerModel
$model = (Get-CimInstance Win32_ComputerSystem).Model
# GET ComputerManufacturer
$manufacturer = (Get-CimInstance Win32_ComputerSystem).Manufacturer

# Prepare JSON
$params = @{ 
    "name"         = "$(hostname)";
    "mac"          = "$mac";
    "serial"       = "$serial";
    "manufacturer" = "$manufacturer";
    "model"        = "$model";
    "comment"      = "Automatically added from Prepare-Environment";
}

# Enable setup
$result = Invoke-RestMethod -Uri "http://windowsreset/api/v1/enable" -Method POST -Body ($params | ConvertTo-Json) -ContentType "application/json"
Write-Host -BackgroundColor Green -ForegroundColor Black $result.message
